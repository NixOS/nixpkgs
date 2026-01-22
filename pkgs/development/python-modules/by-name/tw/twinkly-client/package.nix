{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "twinkly-client";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F/N6yMOvLHIfXvPyR7z3P/Rlh79OvCbvEiNwClLSLl8=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "twinkly_client" ];

  meta = {
    description = "Python module to communicate with Twinkly LED strings";
    homepage = "https://github.com/dr1rrb/py-twinkly-client";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
