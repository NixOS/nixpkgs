{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, unidecode
, python
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "15.02.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8dfe1b295116115695752acc84d15ecf5c1c469975fbed7672bf41a6bc6d6d51";
  };

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [ unidecode ];

  meta = {
    description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
    homepage = https://github.com/mk-fg/pretty-yaml;
    license = lib.licenses.wtfpl;
  };
}