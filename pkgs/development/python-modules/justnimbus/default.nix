{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "justnimbus";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kvanzuijlen";
    repo = pname;
    rev = version;
    hash = "sha256-uQ5Nc5sxqHeAuavyfX4Q6Umsd54aileJjFwOOU6X7Yg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "justnimbus"
  ];

  meta = with lib; {
    description = "Library for the JustNimbus API";
    homepage = "https://github.com/kvanzuijlen/justnimbus";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

