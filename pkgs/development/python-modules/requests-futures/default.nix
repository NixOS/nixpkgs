{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "requests-futures";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9VpO+ABw4oWOfR5zEj0r+uryW5P9NDhNjd8UjitnY3M=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Tests are disabled because they require being online
  doCheck = false;

  pythonImportsCheck = [
    "requests_futures"
  ];

  meta = with lib; {
    description = "Asynchronous Python HTTP Requests for Humans using Futures";
    homepage = "https://github.com/ross/requests-futures";
    changelog = "https://github.com/ross/requests-futures/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ applePrincess ];
  };
}
