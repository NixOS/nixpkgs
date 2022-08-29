{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyrisco";
  version = "0.5.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gRAQARdVZWpFHx0nE4xRktIP2p4ggp9/95VO9nNd/1w=";
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
