{ lib, fetchFromGitHub, buildPythonPackage, isPyPy, isPy3k, libbfd, libopcodes }:

buildPythonPackage {
  pname = "pybfd";
  version = "-0.1.1.2017-12-31";

  disabled = isPyPy || isPy3k;

  src = fetchFromGitHub {
    owner = "orivej";
    repo = "pybfd";
    rev = "a10ada53f2a79de7f62f209567806ef1e91794c7";
    sha256 = "0sxzhlqjyvvx1zr3qrkb57z6s3g6k3ksyn65fdm9lvl0k4dv2k9w";
  };

  LIBBFD_INCLUDE_DIR = "${libbfd.dev}/include";
  LIBBFD_LIBRARY = "${libbfd}/lib/libbfd.so";
  LIBOPCODES_INCLUDE_DIR = "${libopcodes.dev}/include";
  LIBOPCODES_LIBRARY = "${libopcodes}/lib/libopcodes.so";

  meta = {
    homepage = https://github.com/Groundworkstech/pybfd;
    description = "A Python interface to the GNU Binary File Descriptor (BFD) library";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ orivej ];
    broken = true;
  };
}
