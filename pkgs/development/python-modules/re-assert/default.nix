{
  lib,
  buildPythonPackage,
  fetchPypi,
  regex,
}:

buildPythonPackage rec {
  pname = "re_assert";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5172dfbd2047a15dff2347735dea7e495479cc7e58841199a4a4973256b20464";
  };

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = [ regex ];

  meta = {
    description = "Show where your regex match assertion failed";
    license = lib.licenses.mit;
    homepage = "https://github.com/asottile/re-assert";
  };
}
