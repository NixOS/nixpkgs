{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, async-timeout
, aioresponses
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "foobot-async";
  version = "1.0.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "foobot_async";
    inherit version;
    sha256 = "fa557a22de925139cb4a21034ffdbcd01d28bf166c0e680eaf84a99206327f40";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
  ];

  pythonImportsCheck = [ "foobot_async" ];

  meta = with lib; {
    description = "API Client for Foobot Air Quality Monitoring devices";
    homepage = "https://github.com/reefab/foobot_async";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
