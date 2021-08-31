{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, ratelimit
}:

buildPythonPackage rec {
  pname = "goalzero";
  version = "0.1.59";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d0f11aa31672f3ef4ab617db92c87ef6f143804473022405f6da9d830f17638";
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
