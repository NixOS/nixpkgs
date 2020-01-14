{ lib, buildPythonPackage, fetchPypi, cython, libyaml, buildPackages }:

buildPythonPackage rec {
  pname = "PyYAML";
  version = "5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0ee8eca2c582d29c3c2ec6e2c4f703d1b7f1fb10bc72317355a746057e7346c";
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
