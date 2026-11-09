{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyserial,
}:

buildPythonPackage rec {
  pname = "pyserial-asyncio";
  version = "0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tgMpI+BenXXsF6WvmphCnEbSg5rfr4BgTVLg+qzXoy8=";
  };

  propagatedBuildInputs = [ pyserial ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "serial_asyncio" ];

  meta = {
    description = "Asyncio extension package for pyserial";
    homepage = "https://github.com/pyserial/pyserial-asyncio";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
