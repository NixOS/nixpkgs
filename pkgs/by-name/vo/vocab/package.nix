{
  fetchFromGitHub,
  lib,
  python3Packages,
  translate,
}:
python3Packages.buildPythonPackage {
  name = "vocab";
  version = "1.0.0";
  propagagedBuildInputs = [ translate ];
  buildInputs = with python3Packages; [ setuptools ];
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "vocab";
    rev = "e1c11d2570b5f9e8d1a18652391cb6ab7623c574";
    hash = "sha256-3aPc+ivec8M+iD8ZDL+rWJrL+2jVhmcp2Bdc9jxpi3Y=";
  };

  meta = with lib; {
    description = "Learn vocabulary efficiently using the CLI";
    homepage = "https://github.com/NewDawn0/vocab";
    maintainers = with maintainers; [ NewDawn0 ];
    license = licenses.mit;
  };
}
