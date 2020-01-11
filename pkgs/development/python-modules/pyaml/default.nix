{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, unidecode
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "19.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3f636b467864319d7ded1558f86bb305b8612a274f5d443a62dc5eceb1b7176";
  };

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [ unidecode ];

  meta = {
    description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
    homepage = https://github.com/mk-fg/pretty-yaml;
    license = lib.licenses.wtfpl;
  };
}