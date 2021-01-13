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
  version = "2.1.0";
  disabled = !isPy3k; # only Python 3

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0239a4achk49ngagb6aqy6cgzfwgbxir07vwi13ysbpx78y0l4g9";
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
