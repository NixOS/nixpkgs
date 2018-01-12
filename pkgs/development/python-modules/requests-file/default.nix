{lib, fetchPypi, python, buildPythonPackage, isPy27, isPyPy, requests }:

buildPythonPackage rec {
  pname = "requests-file";
  version = "1.4.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "1yp2jaxg3v86pia0q512dg3hz6s9y5vzdivsgrba1kds05ial14g";
  };

  disabled = isPyPy;
  buildInputs = [ requests ];
  meta = {
    description = "File Transport Adapter for Requests";
    homepage = http://github.com/dashea/requests-file;
  };
}
