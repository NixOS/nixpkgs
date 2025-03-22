{ lib
, buildPythonPackage
, fetchFromGitHub
, polib
, pylint
, isPy3k
, python
}:

buildPythonPackage rec {
  pname = "pocketlint";
  version = "0.22";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = pname;
    rev = "c510f8c5a668a28eb5d1fc0045363c4805090831";
    sha256 = "sha256-Ip2b8oaau9csa5y19AwmaB4QohG5IJTmpCPmt9PQpXQ=";
  };

  propagatedBuildInputs = [ polib pylint ];

  # python3 and pypy are not supported
  disabled = !isPy3k;


  # only one test, which isn't included in setup.py
  checkPhase = ''
    ${python.interpreter} tests/pylint/runpylint.py
  '';

  meta = with lib; {
    homepage = "https://github.com/rhinstaller/pocketlint";
    description = "Addon modules for checking the validity of Python projects.";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.govanify ];
  };

}
