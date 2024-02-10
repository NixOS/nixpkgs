{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "future-fstrings";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "future_fstrings";
    sha256 = "6cf41cbe97c398ab5a81168ce0dbb8ad95862d3caf23c21e4430627b90844089";
  };

  # No tests included in Pypi archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/asottile/future-fstrings";
    description = "A backport of fstrings to python<3.6";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
    broken = pythonOlder "3.6"; # dependency tokenize-rt not packaged
  };
}
