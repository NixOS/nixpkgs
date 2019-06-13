{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "cfgv";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vxjwga8x9nn5xqbhf5sql7jab3s1la07mxbaqgcfjz8lpp2z7vf";
  };

  propagatedBuildInputs = [ six ];

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Validate configuration and produce human readable error messages";
    homepage = https://github.com/asottile/cfgv;
    license = licenses.mit;
  };
}
