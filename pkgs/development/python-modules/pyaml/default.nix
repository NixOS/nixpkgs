{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, unidecode
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "17.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "66623c52f34d83a2c0fc963e08e8b9d0c13d88404e3b43b1852ef71eda19afa3";
  };

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [ unidecode ];

  meta = {
    description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
    homepage = https://github.com/mk-fg/pretty-yaml;
    license = lib.licenses.wtfpl;
  };
}