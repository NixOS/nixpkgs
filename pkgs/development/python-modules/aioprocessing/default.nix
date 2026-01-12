{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
}:

buildPythonPackage rec {
  pname = "aioprocessing";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/gHHsaOMeBaGEdMEDnPZMDbDt8imSdY23J7Xo7ybG6I=";
  };

  nativeBuildInputs = [ flit-core ];

  # Tests aren't included in pypi package
  doCheck = false;

  pythonImportsCheck = [ "aioprocessing" ];

  meta = {
    description = "Library that integrates the multiprocessing module with asyncio";
    homepage = "https://github.com/dano/aioprocessing";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ uskudnik ];
  };
}
