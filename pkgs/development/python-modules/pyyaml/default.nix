{ lib, buildPythonPackage, fetchPypi, cython, libyaml, buildPackages }:

buildPythonPackage rec {
  pname = "PyYAML";
  version = "5.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4bb4d3f5e232425e25dda21c070ce05168a786ac9eda43768ab7f3ac2770955";
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
