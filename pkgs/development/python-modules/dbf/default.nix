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
  version = "0.99.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MFEi1U0RNvrfDtV4HpvPgKTCibAh76z7Gnmj32IubYw=";
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
