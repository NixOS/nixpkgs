{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, ratelimit
}:

buildPythonPackage rec {
  pname = "goalzero";
  version = "0.2.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6cb67cf772a758225b2e23b394feb697e8cbfb1aff5a2d7a17a0d4ccf61e55cd";
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
