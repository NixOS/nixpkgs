{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  direnv,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xonsh-direnv";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "greg-hellings";
    repo = pname;
    rev = version;
    hash = "sha256-LPSYUK07TQuTI+u0EmUuGL48znUfRDVGEIS/mmzcETU=";
  };

  prePatch = ''
    substituteInPlace xontrib/direnv.xsh \
      --replace '__direnv_post_rc()' \
                '__direnv_post_rc(**kwargs)' \
      --replace '__direnv_chdir(olddir: str, newdir: str)' \
                '__direnv_chdir(olddir: str, newdir: str, **kwargs)' \
      --replace '__direnv_postcommand(cmd: str, rtn: int, out: str or None, ts: list)' \
                '__direnv_postcommand(cmd: str, rtn: int, out: str or None, ts: list, **kwargs)'
  '';

  propagatedBuildInputs = [
    direnv
  ];

  nativeBuildInputs = [
    setuptools
  ];

  meta = with lib; {
    description = "Direnv support for Xonsh";
    homepage = "https://github.com/74th/xonsh-direnv/";
    license = licenses.mit;
    maintainers = with maintainers; [ greg ];
  };
}
