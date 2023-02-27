{ lib
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "retrying";
  version = "1.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NF2oxXZb2YKx0ZFd65EC/T0fetFr2EqXALhfZNJOjz4=";
  };

  propagatedBuildInputs = [
    six
  ];

  # doesn't ship tests in tarball
  doCheck = false;

  pythonImportsCheck = [
    "retrying"
  ];

  meta = with lib; {
    description = "General-purpose retrying library";
    homepage = "https://github.com/rholder/retrying";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
