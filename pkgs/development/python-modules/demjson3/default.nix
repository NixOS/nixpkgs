{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
}:

buildPythonPackage rec {
  pname = "demjson3";
  version = "3.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N8g7DG6wjSXe/IjfCipIddWKeAmpZQvW7uev2AU826w=";
  };

  checkPhase = ''
    ${python.interpreter} test/test_demjson3.py
  '';

  pythonImportsCheck = [ "demjson3" ];

  meta = {
    description = "Encoder/decoder and lint/validator for JSON (JavaScript Object Notation)";
    mainProgram = "jsonlint";
    homepage = "https://github.com/nielstron/demjson3/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
