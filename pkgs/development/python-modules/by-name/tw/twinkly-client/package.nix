{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "twinkly-client";
  version = "0.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F/N6yMOvLHIfXvPyR7z3P/Rlh79OvCbvEiNwClLSLl8=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "twinkly_client" ];

  meta = with lib; {
    description = "Python module to communicate with Twinkly LED strings";
    homepage = "https://github.com/dr1rrb/py-twinkly-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
