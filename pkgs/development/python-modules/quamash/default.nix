{ lib, buildPythonPackage, fetchFromGitHub, pytest, isPy3k, pyqt5, pyqt ? pyqt5 }:

buildPythonPackage rec {
  pname = "quamash";
  version = "0.6.1";

  disabled = !isPy3k;

  # No tests in PyPi tarball
  src = fetchFromGitHub {
    owner = "harvimt";
    repo = "quamash";
    rev = "version-${version}";
    sha256 = "117rp9r4lz0kfz4dmmpa35hp6nhbh6b4xq0jmgvqm68g9hwdxmqa";
  };

  propagatedBuildInputs = [ pyqt ];

  checkInputs = [ pytest ];
  checkPhase = ''
     pytest -k 'test_qthreadexec.py' # the others cause the test execution to be aborted, I think because of asyncio
  '';

  meta = with lib; {
    description = "Implementation of the PEP 3156 event-loop (asyncio) api using the Qt Event-Loop";
    homepage = https://github.com/harvimt/quamash;
    license = licenses.bsd2;
    maintainers = with maintainers; [ borisbabic ];
  };
}
