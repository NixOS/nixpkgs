{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-warnings";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18yxh153icmndaw8fkl1va0bk0mwzrbpaa6wxd29w3iwxym5zn2a";
  };

  propagatedBuildInputs = [ pytest ];

  meta = {
    description = "Plugin to list Python warnings in pytest report";
    homepage = https://github.com/fschulze/pytest-warnings;
    license = lib.licenses.mit;
  };
}
