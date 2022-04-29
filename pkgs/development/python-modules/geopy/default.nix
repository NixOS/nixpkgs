{ lib
, async_generator
, buildPythonPackage
, fetchFromGitHub
, geographiclib
, isPy3k
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "geopy";
  version = "2.2.0";
  disabled = !isPy3k; # only Python 3

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-zFz0T/M/CABKkChuiKsFkWj2pphZuFeE5gz0HxZYaz8=";
  };

  propagatedBuildInputs = [ geographiclib ];

  checkInputs = [
    async_generator
    pytestCheckHook
  ];

  # Exclude tests which perform API calls
  pytestFlagsArray = [ "--ignore test/geocoders/" ];
  pythonImportsCheck = [ "geopy" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    changelog = "https://github.com/geopy/geopy/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
