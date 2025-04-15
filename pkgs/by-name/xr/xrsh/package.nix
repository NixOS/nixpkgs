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
  version = "0-unstable-2025-03-28";

  src = fetchFromGitea {
    fetchSubmodules = true;
    domain = "codeberg.org";
    owner = "xrsh";
    repo = "xrsh";
    rev = "6eb4feb04ddd4aa96319340921d12b9fdd1bbe59";
    hash = "sha256-EPrp9tsBDo7A4Si0wV8cup3zOBeMG3em1ePSZwjXUcI=";
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
