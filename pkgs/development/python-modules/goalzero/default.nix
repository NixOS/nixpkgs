{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, ratelimit
}:

buildPythonPackage rec {
  pname = "goalzero";
  version = "0.1.7";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f6a2755a745ea14e65d6bf3e56bd090a508bf6f63ccb76b9b89ce3d844a2160";
  };

  propagatedBuildInputs = [
    aiohttp
    ratelimit
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "goalzero" ];

  meta = with lib; {
    description = "Goal Zero Yeti REST Api Library";
    homepage = "https://github.com/tkdrob/goalzero";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
