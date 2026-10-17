{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vcs_query";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mageta";
    repo = "vcs_query";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nWbpuTs52X1ktatstpZwDCMSUJmjg50qxHd2n5QFahc=";
  };

  nativeBuildInputs = [
    python3
    python3.pkgs.wrapPython
  ];

  dontBuild = true;

  installPhase = ''
    install -Dm0755 vcs_query.py $out/bin/vcs_query
    patchShebangs $out/bin
    buildPythonPath ${python3.pkgs.vobject};
    patchPythonScript $out/bin/vcs_query
  '';

  meta = {
    homepage = "https://github.com/mageta/vcs_query";
    description = "Email query-command to use vCards in mutt and Vim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
    mainProgram = "vcs_query";
  };
})
