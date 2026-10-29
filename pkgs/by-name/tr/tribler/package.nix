{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  libappindicator,
  nix-update-script,
  nodejs_24,
  python3,
  wrapGAppsHook3,
}:
let
  version = "8.4.3";
  nodejs = nodejs_24;

  src = fetchFromGitHub {
    owner = "tribler";
    repo = "Tribler";
    tag = "v${version}";
    hash = "sha256-5ykIQBvYKzGn9toXb2248ulvh22fJlE0mNQkilkWRYo=";
  };

  tribler-webui = buildNpmPackage {
    inherit nodejs version;
    pname = "tribler-webui";
    src = "${src}/src/tribler/ui";
    npmDepsHash = "sha256-3VS2E7YFI2UHWv8zbExR+i+SuLvq70mDaObDqYMIgP0=";

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
  pname = "tribler";
  pyproject = true;

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    # requirements.txt
    configobj
    ipv8-rust-tunnels
    libtorrent-rasterbar
    lz4
    pillow
    pony
    pyipv8
    pystray

    # build/requirements.txt
    cx-freeze
    requests
  ];

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = with python3.pkgs; [
    # setup.py requirements
    pygobject3
    # sphinx requirements
    sphinxHook
    sphinx
    sphinx-autoapi
    sphinx-rtd-theme
    astroid
    # tray icon deps
    libappindicator
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  outputs = [
    "out"
  ];

  postPatch = ''
    # fix the entrypoint
    substituteInPlace build/setup.py --replace-fail '"tribler=tribler.run:main"' '"tribler=tribler.run:main_sync"'
    substituteInPlace src/run_tribler.py --replace-fail 'if __name__ == "__main__":' 'def main_sync():'

    # ValueError: ZIP does not support timestamps before 1980
    substituteInPlace build/win/build.py --replace-fail "if {'setup.py', 'bdist_wheel'}.issubset(sys.argv):" "if True:"

    # copy the built webui
    rm -r src/tribler/ui
    ln -s ${tribler-webui} src/tribler/ui
  '';

  buildPhase = ''
    runHook preBuild

    export GITHUB_TAG=v${version}
    python3 build/debian/update_metainfo.py
    python3 build/setup.py bdist_wheel

    runHook postBuild
  '';

  postInstall = ''
    ln -s ${tribler-webui} $out/${python3.sitePackages}/tribler/ui
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" [ libappindicator ]}"
    )
  '';

  disabledTestPaths = [
    # Tests are outdated
    "src/tribler/test_unit/core/content_discovery/restapi/"
    "src/tribler/test_unit/core/database/restapi/"
    "src/tribler/test_unit/core/libtorrent/restapi/"
    "src/tribler/test_unit/core/restapi/"
    "src/tribler/test_unit/core/versioning/restapi/"
  ];

  disabledTests = [
    "test_request_for_version"
    "test_establish_connection"
    "test_tracker_test_error_resolve"
    "test_get_default_fallback"
    "test_get_default_fallback_half_tree"
    "test_get_set_explicit"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Decentralized P2P filesharing client based on the Bittorrent protocol";
    homepage = "https://www.tribler.org/";
    changelog = "https://github.com/Tribler/tribler/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      mkg20001
      mlaradji
      xvapx
    ];
    mainProgram = "tribler";
    platforms = lib.platforms.linux;
  };
}
