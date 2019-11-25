{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, unidecode
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "19.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c79ae98ececda136a034115ca178ee8bf3aa7df236c488c2f55d12f177b88f1e";
  };

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [ unidecode ];

  meta = {
    description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
    homepage = https://github.com/mk-fg/pretty-yaml;
    license = lib.licenses.wtfpl;
  };
}