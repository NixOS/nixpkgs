{ stdenv, buildPythonPackage, fetchurl, python }:

with python.pkgs;

buildPythonPackage rec {
  pname = "portend";
  name = "${pname}-${version}";
  version = "1.8";

  src = fetchurl {
    url = "mirror://pypi/p/portend/${name}.tar.gz";
    sha256 = "0qamvqpwpn29cbg2gi5pcnk1lrlhf9as507yd13hvija5jw1ksbx";
  };

  buildInputs = [ setuptools_scm pytest mock ];
  propagatedBuildInputs = [ tempora ];
}
