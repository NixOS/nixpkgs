{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "pathtools";
  version = "0.1.2";
  format = "setuptools";

  # imp and distuils usage, last commit in 2016
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h7iam33vwxk8bvslfj4qlsdprdnwf8bvzhqh3jq5frr391cadbw";
  };

  meta = with lib; {
    description = "Pattern matching and various utilities for file systems paths";
    homepage = "https://github.com/gorakhargosh/pathtools";
    license = licenses.mit;
    maintainers = [ ];
  };
}
