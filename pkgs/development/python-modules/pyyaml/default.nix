{ lib, buildPythonPackage, fetchPypi, cython, libyaml, buildPackages }:

buildPythonPackage rec {
  pname = "PyYAML";
  version = "5.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4";
  };

  # force regeneration using Cython
  postPatch = ''
    rm ext/_yaml.c
  '';

  nativeBuildInputs = [ cython buildPackages.stdenv.cc ];

  buildInputs = [ libyaml ];

  meta = with lib; {
    description = "The next generation YAML parser and emitter for Python";
    homepage = https://github.com/yaml/pyyaml;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
