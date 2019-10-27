{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, unidecode
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "18.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b96292cc409e0f222b6fecff96afd2e19cfab5d1f2606344907751d42301263a";
  };

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [ unidecode ];

  meta = {
    description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
    homepage = https://github.com/mk-fg/pretty-yaml;
    license = lib.licenses.wtfpl;
  };
}