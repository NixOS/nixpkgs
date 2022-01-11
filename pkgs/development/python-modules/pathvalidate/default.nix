{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "pathvalidate";
  version = "2.5.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "119ba36be7e9a405d704c7b7aea4b871c757c53c9adc0ed64f40be1ed8da2781";
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
