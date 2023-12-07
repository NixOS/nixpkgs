{ fetchPypi, buildPythonPackage, pygtrie, isPy3k, lib, }:
buildPythonPackage rec {
  pname = "betacode";
  version = "1.0";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0s84kd9vblbjz61q7zchx64a6hmdqb4lillna5ryh0g9ij76g6r5";
  };
  preBuild = "echo > README.rst";
  # setup.py uses a python3 os.path.join
  disabled = !isPy3k;
  propagatedBuildInputs = [ pygtrie ];
  meta = {
    homepage = "https://github.com/matgrioni/betacode";
    description = "A small python package to flexibly convert from betacode to unicode and back.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
