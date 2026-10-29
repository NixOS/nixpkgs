{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyserial,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyserial-asyncio";
  version = "0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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
})
