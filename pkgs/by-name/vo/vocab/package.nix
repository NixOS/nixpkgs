{
  fetchFromGitHub,
  lib,
  python3Packages,
  translate,
}:
python3Packages.buildPythonPackage {
  pname = "vocab";
  version = "1.0.0";
  propagagedBuildInputs = [ translate ];
  buildInputs = with python3Packages; [ setuptools ];
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "vocab";
    rev = "e1c11d2570b5f9e8d1a18652391cb6ab7623c574";
    hash = "sha256-3aPc+ivec8M+iD8ZDL+rWJrL+2jVhmcp2Bdc9jxpi3Y=";
  };
  meta = {
    description = "An efficient CLI-based tool for vocabulary learning";
    longDescription = ''
      This command-line tool helps you learn and memorize vocabulary efficiently.
      It provides a simple way to learn vocabulary from a file, with autocorrection and automatic translation.
    '';
    homepage = "https://github.com/NewDawn0/vocab";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
}
