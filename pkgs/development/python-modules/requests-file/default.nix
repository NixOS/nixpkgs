{ stdenv, lib, fetchPypi, python, buildPythonPackage, requests }:

buildPythonPackage rec {
  pname = "requests-file";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "1yp2jaxg3v86pia0q512dg3hz6s9y5vzdivsgrba1kds05ial14g";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "File Transport Adapter for Requests";
    homepage = http://github.com/dashea/requests-file;
    license = stdenv.lib.licenses.asl20;
  };
}
