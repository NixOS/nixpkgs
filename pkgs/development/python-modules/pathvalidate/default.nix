{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "pathvalidate";
  version = "2.5.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-u8J+ZTM1q6eTWireIpliLnapSHvJAEzc8UQc6NL/SlQ=";
  };

  # Requires `pytest-md-report`, causing infinite recursion.
  doCheck = false;

  pythonImportsCheck = [ "pathvalidate" ];

  meta = with lib; {
    description = "A Python library to sanitize/validate a string such as filenames/file-paths/etc";
    homepage = "https://github.com/thombashi/pathvalidate";
    license = licenses.mit;
    maintainers = with maintainers; [ oxalica ];
  };
}
