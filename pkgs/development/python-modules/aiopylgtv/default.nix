{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pythonOlder,
  sqlitedict,
  websockets,
}:

buildPythonPackage rec {
  pname = "aiopylgtv";
  version = "0.4.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bendavid";
    repo = "aiopylgtv";
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

<<<<<<< HEAD
  meta = {
    description = "Python library to control webOS based LG TV units";
    mainProgram = "aiopylgtvcommand";
    homepage = "https://github.com/bendavid/aiopylgtv";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python library to control webOS based LG TV units";
    mainProgram = "aiopylgtvcommand";
    homepage = "https://github.com/bendavid/aiopylgtv";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
