{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "future-fstrings";
  version = "0.4.5";

  src = fetchPypi {
    inherit version;
    pname = "future_fstrings";
    sha256 = "891c5d5f073b3e3ff686bebde0a4c45c479065f45c8cbd6de19323d5a50738a8";
  };

  # No tests included in Pypi archive
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/asottile/future-fstrings;
    description = "A backport of fstrings to python<3.6";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
    broken = pythonOlder "3.6"; # dependency tokenize-rt not packaged
  };
}
