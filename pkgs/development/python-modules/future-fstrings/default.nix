{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "future-fstrings";
  version = "1.0.0";

  src = fetchPypi {
    inherit version;
    pname = "future_fstrings";
    sha256 = "1pra33in6rinrcs5wvdb1rbxmx223j93ahdwhzwgf7wyfsnjda98";
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
