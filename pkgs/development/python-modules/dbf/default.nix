{
  lib,
  fetchPypi,
  buildPythonPackage,
  aenum,
  python,
}:

buildPythonPackage rec {
  pname = "dbf";
  version = "0.99.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IWnAUlLA776JfzRvBoMybsJYVL6rHQxkMN9ukDpXsxU=";
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

  meta = {
    description = "Module for reading/writing dBase, FoxPro, and Visual FoxPro .dbf files";
    homepage = "https://github.com/ethanfurman/dbf";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
