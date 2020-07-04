{ stdenv, buildPythonPackage, isPy27, fetchPypi }:

buildPythonPackage rec {
  pname = "libevdev";
  version = "0.7";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "10gwj08kn2rs4waq7807mq34cbavgkpg8fpir8mvnba601b8q4r4";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python wrapper around the libevdev C library";
    homepage = "https://gitlab.freedesktop.org/libevdev/python-libevdev";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
  };
}
