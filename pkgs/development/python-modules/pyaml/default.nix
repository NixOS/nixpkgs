{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, unidecode
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "20.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "29a5c2a68660a799103d6949167bd6c7953d031449d08802386372de1db6ad71";
  };

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [ unidecode ];

  meta = {
    description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
    homepage = "https://github.com/mk-fg/pretty-yaml";
    license = lib.licenses.wtfpl;
  };
}
