{ fetchFromGitHub, buildPythonPackage, pygtrie, isPy3k, lib, }:
buildPythonPackage rec {
  pname = "betacode";
  version = "1.0";
  src = fetchFromGitHub {
     owner = "matgrioni";
     repo = "betacode";
     rev = "v1.0";
     sha256 = "1fcix00g7zwgwbi0gfzq544y8i10b8h5hlarq469isyh3x4jz08g";
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
