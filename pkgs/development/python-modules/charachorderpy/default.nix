{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  inquirer,
  pyserial,
  setuptools,
}:

let
  version = "0.6.0";
in
buildPythonPackage {
  pname = "charachorder.py";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CharaChorder";
    repo = "charachorder.py";
    tag = "v${version}";
    hash = "sha256-IQ7mNhiBFGUK05W8fYsuIwDK/uBjvV1RUgQgXgCDas0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    inquirer
    pyserial
  ];

  pythonImportsCheck = [ "charachorder" ];

  meta = {
    description = "Wrapper for CharaChorder's Serial API written in Python";
    downloadPage = "https://pypi.org/project/charachorder.py/#files";
    homepage = "https://github.com/CharaChorder/charachorder.py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getpsyched ];
    platforms = lib.platforms.all;
  };
}
