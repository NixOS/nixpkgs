{
  buildPythonPackage,
  fetchPypi,
  requests,
  six,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "hypchat";
  version = "0.21";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7zepzYEDuxOtdysoupIjyp1CeDceN0RQw+opGN9wqOk=";
  };

  propagatedBuildInputs = [
    requests
    six
    python-dateutil
  ];
}
