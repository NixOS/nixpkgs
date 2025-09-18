{
  lib,
  stdenv,
  python312,
  makeWrapper,
  nix-update-script,
  fetchFromGitHub,
  rustPlatform,
  buildNpmPackage,
  nodejs_24,
  wrapGAppsHook3,
  libappindicator-gtk3,
}:
let
  version = "8.2.3";
  python3 = python312;
  nodejs = nodejs_24;

  src = fetchFromGitHub {
    owner = "tribler";
    repo = "Tribler";
    tag = "v${version}";
    hash = "sha256-yThl3HhPtwi/pK5Rcr2ClVLY8uCnIyfvdc53A8gjKDg=";
  };

  tribler-webui = buildNpmPackage {
    inherit nodejs version;
    pname = "tribler-webui";
    src = "${src}/src/tribler/ui";
    npmDepsHash = "sha256-bgRwhqP6/NMPFbZks31IZtVGV9wzFFU6qSgyLvdarlY=";

    # The prepack script runs the build script, which we'd rather do in the build phase.
    npmPackFlags = [ "--ignore-scripts" ];

    NODE_OPTIONS = "--openssl-legacy-provider";

    dontNpmBuild = true;
    dontNpmInstall = true;

    installPhase = ''
      mkdir -pv $out
      cp -prvd ./* $out/
      cd $out
      npm install
      npm run build
    '';
  };

in

python3.pkgs.buildPythonApplication {
  inherit version src;
  name = "tribler";
  pyproject = true;

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    # requirements.txt
    bitarray
    configobj
    pyipv8
    ipv8-rust-tunnels
    libtorrent-rasterbar
    lz4
    pillow
    pony
    pystray
  ];

  buildInputs = with python3.pkgs; [
    # setup.py requirements
    pygobject3
    setuptools
    # sphinx requirements
    sphinxHook
    sphinx
    sphinx-autoapi
    sphinx-rtd-theme
    astroid
    # tray icon deps
    wrapGAppsHook3
    libappindicator-gtk3
    # test phase requirements
    pytestCheckHook

  ];

  outputs = [
    "out"
  ];

  buildPhase = ''
          # fix the entrypoint
          substituteInPlace build/setup.py --replace-fail '"tribler=tribler.run:main"' '"tribler=tribler.run:main_sync"'
          substituteInPlace src/run_tribler.py --replace-fail 'if __name__ == "__main__":' 'def main_sync():'

          # copy the built webui
          rm -r src/tribler/ui
          ln -s ${tribler-webui} src/tribler/ui

          # build the docs
    # FIXME:      make doc SPHINXBUILD=${lib.getExe' python3.pkgs.sphinx "sphinx-build"}

          # build the wheel
          substituteInPlace build/win/build.py --replace-fail "if {'setup.py', 'bdist_wheel'}.issubset(sys.argv):" "if True:"
          export GITHUB_TAG=v${version}
          python3 build/debian/update_metainfo.py
          python3 build/setup.py bdist_wheel

        runHook pytestCheckHook

          # build the docs
        runHook sphinxHook
  '';

  postInstall = ''
    ln -s ${tribler-webui} $out/lib/python3.12/site-packages/tribler/ui
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" [ libappindicator-gtk3 ]}"
    )
  '';

  postFixup = ''
    runHook wrapGAppsHook3
  '';

  disabledTests = [
    "test_request_for_version"
    "test_establish_connection"
    "test_tracker_test_error_resolve"
    "test_get_default_fallback"
    "test_get_default_fallback_half_tree"
    "test_get_set_explicit"
  ];

  disabledTestPaths = [
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Decentralized P2P filesharing client based on the Bittorrent protocol";
    mainProgram = "tribler";
    homepage = "https://www.tribler.org/";
    changelog = "https://github.com/Tribler/tribler/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      mkg20001
      mlaradji
      xvapx
    ];
    platforms = lib.platforms.linux;
  };
}
