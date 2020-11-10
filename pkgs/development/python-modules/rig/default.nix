{ lib, buildPythonPackage, fetchPypi
, isPy35, isPy27
, numpy, pytz, six, enum-compat, sentinel
}:

buildPythonPackage rec {
  pname = "rig";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a3896dbde3f291c5dd34769e7329ef5d5e4da34fee53479bd13dc5e5d540b8a";
  };

  propagatedBuildInputs = [ numpy pytz six sentinel enum-compat ];

  # This is the list of officially supported versions. Other versions may work
  # as well.
  disabled = !(isPy27 || isPy35);

  # Test Phase is only supported in development sources.
  doCheck = false;

  meta = with lib; {
    description = "A collection of tools for developing SpiNNaker applications";
    homepage = "https://github.com/project-rig/rig";
    license = licenses.gpl2;
  };
}
