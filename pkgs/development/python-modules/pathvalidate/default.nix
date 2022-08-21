{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "pathvalidate";
  version = "2.5.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-X/V9D6vl7Lek8eSVe/61rYq1q0wPpx95xrvCS9m30U0=";
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
