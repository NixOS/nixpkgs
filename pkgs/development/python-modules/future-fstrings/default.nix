{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "future-fstrings";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "future_fstrings";
    hash = "sha256-bPQcvpfDmKtagRaM4Nu4rZWGLTyvI8IeRDBie5CEQIk=";
  };

  # No tests included in Pypi archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/asottile/future-fstrings";
    description = "Backport of fstrings to python<3.6";
    mainProgram = "future-fstrings-show";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
    broken = pythonOlder "3.6"; # dependency tokenize-rt not packaged
  };
}
