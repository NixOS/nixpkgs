{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyrisco";
  version = "0.3.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = pname;
    rev = "v${version}";
    sha256 = "1im29h4rxnp98aqzgzjj5i8jv2h5zw9c5yx8xxzl4cmr3yila9zw";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyrisco" ];

  meta = with lib; {
    description = "Python interface to Risco alarm systems through Risco Cloud";
    homepage = "https://github.com/OnFreund/pyrisco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
