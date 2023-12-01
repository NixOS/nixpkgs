{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pythonOlder
, sqlitedict
, websockets
}:

buildPythonPackage rec {
  pname = "aiopylgtv";
  version = "0.4.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bendavid";
    repo = pname;
    rev = version;
    hash = "sha256-NkWJGy5QUrhpbARoscrXy/ilCjAz01YxeVTH0I+IjNM=";
  };

  propagatedBuildInputs = [
    numpy
    sqlitedict
    websockets
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "aiopylgtv" ];

  meta = with lib; {
    description = "Python library to control webOS based LG TV units";
    homepage = "https://github.com/bendavid/aiopylgtv";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
