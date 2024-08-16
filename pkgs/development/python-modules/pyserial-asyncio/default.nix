{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pyserial,
}:

buildPythonPackage rec {
  pname = "pyserial-asyncio";
  version = "0.6";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tgMpI+BenXXsF6WvmphCnEbSg5rfr4BgTVLg+qzXoy8=";
  };

  propagatedBuildInputs = [ pyserial ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "serial_asyncio" ];

  meta = with lib; {
    description = "Asyncio extension package for pyserial";
    homepage = "https://github.com/pyserial/pyserial-asyncio";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
