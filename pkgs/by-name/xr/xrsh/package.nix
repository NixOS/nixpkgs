{
  lib,
  stdenv,
  fetchFromGitea,
  makeWrapper,
  unstableGitUpdater,
  writeShellApplication,
  python3Packages,
}:

stdenv.mkDerivation {
  pname = "xrsh";
  version = "0-unstable-2025-04-18";

  src = fetchFromGitea {
    fetchSubmodules = true;
    domain = "codeberg.org";
    owner = "xrsh";
    repo = "xrsh";
    rev = "f9ca00efb864447ceac94d3e8134a7ed4c41a590";
    hash = "sha256-2nGG6B+uW2QEdIjg8NXQjtbIQu+1hhOSKeHFQenc6eI=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase =
    let
      launcher = writeShellApplication {
        name = "xrsh";
        runtimeInputs = [ python3Packages.twisted ];
        text = ''
          XRSH_ROOT="''${1}"
          XRSH_PORT="''${XRSH_PORT-8080}"

          exec twistd -n web --listen "tcp:''${XRSH_PORT}" --path "''${XRSH_ROOT}"
        '';
      };
    in
    ''
      runHook preInstall

      mkdir -p $out/{bin,share/xrsh}
      cp -r -t $out/share/xrsh index.html src xrsh.js xrsh.ico xrsh.svg

      makeWrapper ${lib.getExe launcher} $out/bin/xrsh \
        --add-flags "${placeholder "out"}/share/xrsh/src"

      runHook postInstall
    '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    mainProgram = "xrsh";
    description = "Terminal for WebXR to run REPLs & linux ISO";
    license = lib.licenses.gpl3Plus;
    homepage = "https://xrsh.isvery.ninja";
    maintainers = with lib.maintainers; [ coderofsalvation ];
    platforms = lib.platforms.all;
  };
}
