{ stdenv, buildPythonPackage, fetchurl, python }:

with python.pkgs;

buildPythonPackage rec {
  name = "cheroot-${version}";
  version = "5.5.0";

  src = fetchurl {
    url = "mirror://pypi/c/cheroot/${name}.tar.gz";
    sha256 = "1fhyk8lgs2blfx4zjvwsy6f0ynrs5fwnnr3qf07r6c4j3gwlkqsr";
  };

  buildInputs = [ setuptools_scm pytest portend mock ];
  propagatedBuildInputs = [ six ];
}
