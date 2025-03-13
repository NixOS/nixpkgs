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
  version = "0-unstable-2025-02-28";

  src = fetchFromGitea {
    fetchSubmodules = true;
    domain = "codeberg.org";
    owner = "xrsh";
    repo = "xrsh";
    rev = "5d6e9f4615e57f01ba0859000d90f4f162a06653";
    hash = "sha256-9I6c1GkO7XQZ242ZBCxPiPxkZaYYi/UDLoUvS6nE+M0=";
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
