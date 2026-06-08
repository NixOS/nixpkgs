{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  mypy,
}:

buildPythonPackage rec {
  pname = "pytokens";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KSBS/oCSOq4iYMBz+CLOuiHzhyztmmi7eVOzSOVhF5o=";
  };

  build-system = [
    setuptools
    mypy
  ];

  pythonImportsCheck = [ "pytokens" ];

  meta = with lib; {
    description = "A Fast, spec compliant Python 3.14+ tokenizer that runs on older Pythons.";
    homepage = "https://github.com/tusharsadhwani/pytokens";
    license = licenses.mit;
    mainProgram = "pytokens";
    maintainers = with lib.maintainers; [ singhc7 ];
  };
}
