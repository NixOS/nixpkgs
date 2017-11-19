{ lib, fetchFromGitHub, buildPythonPackage, isPyPy, isPy3k, libbfd, libopcodes }:

buildPythonPackage rec {
  name = "pybfd-0.1.1";

  disabled = isPyPy || isPy3k;

  src = fetchFromGitHub {
    owner = "orivej";
    repo = "pybfd";
    rev = "a2c3a7b94a3c9f7a353b863f69a79174c6a41ebe";
    sha256 = "0wrz234dz25hs0ajzcz5w8lzc1yzf64wqa8fj01hhr4yy23vjkcr";
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
  };
}
