{ stdenv, lib, fetchFromGitHub, cmake, expat, libyamlcpp, ilmbase, pystring, lcms2, python3Packages }:

with lib;

stdenv.mkDerivation rec {
  pname = "opencolorio";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenColorIO";
    rev = "v${version}";
    sha256 = "194j9jp5c8ws0fryiz936wyinphnpzwpqnzvw9ryx6rbiwrba487";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ expat libyamlcpp ilmbase pystring lcms2 python3Packages.pybind11 ];

  cmakeFlags = [ "-DOCIO_INSTALL_EXT_PACKAGES=NONE" ];

  meta = with lib; {
    homepage = "https://opencolorio.org";
    description = "A color management framework for visual effects and animation";
    license = licenses.bsd3;
    maintainers = [ maintainers.rytone ];
    platforms = platforms.unix;
  };
}
