{ lib, buildPythonPackage, fetchPypi, libyaml, buildPackages }:

buildPythonPackage rec {
  pname = "PyYAML";
  version = "3.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf";
  };

  nativeBuildInputs = [ buildPackages.stdenv.cc ];

  propagatedBuildInputs = [ libyaml ];

  meta = with lib; {
    description = "The next generation YAML parser and emitter for Python";
    homepage = https://github.com/yaml/pyyaml;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
