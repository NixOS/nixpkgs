{
  lib,
  fetchPypi,
  buildPythonPackage,
  aenum,
  pythonOlder,
  python,
}:

buildPythonPackage rec {
  pname = "dbf";
  version = "0.99.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UAK7eleaUwLT22Nzjv4+nSUy6lSm9jAXbTUmQW/+AKI=";
  };

  # Workaround for https://github.com/ethanfurman/dbf/issues/48
  patches = lib.optional python.stdenv.hostPlatform.isDarwin ./darwin.patch;

  propagatedBuildInputs = [ aenum ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m dbf.test
    runHook postCheck
  '';

  pythonImportsCheck = [ "dbf" ];

  meta = with lib; {
    description = "Module for reading/writing dBase, FoxPro, and Visual FoxPro .dbf files";
    homepage = "https://github.com/ethanfurman/dbf";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
