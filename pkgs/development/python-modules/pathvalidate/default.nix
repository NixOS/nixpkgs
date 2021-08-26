{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "pathvalidate";
  version = "2.4.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PJvZTH7CPpz7IR/741audfl51sCZosdF7pSQ9STzJGg=";
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
