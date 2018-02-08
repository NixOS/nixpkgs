{ lib, buildPythonPackage, fetchPypi, libyaml }:

buildPythonPackage rec {
  pname = "PyYAML";
  version = "3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab";
  };

  propagatedBuildInputs = [ libyaml ];

  meta = with lib; {
    description = "The next generation YAML parser and emitter for Python";
    homepage = https://github.com/yaml/pyyaml;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
