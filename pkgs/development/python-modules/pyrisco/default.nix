{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyrisco";
  version = "0.5.8";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PQ1h9UVQ2DQMInxdAaLES7uDWAxwDra+YfAmz5jjV6g=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pyrisco"
  ];

  meta = with lib; {
    description = "Python interface to Risco alarm systems through Risco Cloud";
    homepage = "https://github.com/OnFreund/pyrisco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
