{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioprocessing";
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/gHHsaOMeBaGEdMEDnPZMDbDt8imSdY23J7Xo7ybG6I=";
  };

  nativeBuildInputs = [ flit-core ];

  # Tests aren't included in pypi package
  doCheck = false;

  pythonImportsCheck = [ "aioprocessing" ];

  meta = with lib; {
    description = "Library that integrates the multiprocessing module with asyncio";
    homepage = "https://github.com/dano/aioprocessing";
    license = licenses.bsd2;
    maintainers = with maintainers; [ uskudnik ];
  };
}
