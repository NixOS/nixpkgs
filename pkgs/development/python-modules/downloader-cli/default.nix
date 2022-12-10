{ lib
, buildPythonPackage
, fetchFromGitHub
, urllib3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "downloader-cli";
  version = "0.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = pname;
    rev = version;
    hash = "sha256-Dl5XIvdZInz+edL9uQv7V6Kc6FB+7hFAGe/nybnqvQU=";
  };

  propagatedBuildInputs = [
    urllib3
  ];

  # Disable checks due to networking (Errno 101)
  doCheck = false;

  pythonImportsCheck = [
    "downloader_cli"
  ];

  meta = with lib; {
    description = "Downloader with an awesome customizable progressbar";
    homepage = "https://github.com/deepjyoti30/downloader-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
