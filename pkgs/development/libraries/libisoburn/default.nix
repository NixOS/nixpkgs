{ lib, stdenv, fetchurl, acl, attr, zlib, libburn, libisofs }:

stdenv.mkDerivation rec {
  pname = "libisoburn";
  version = "1.5.6";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-K4Cm9z3WM6XSQ/rL6XoV5cmgdkSl4aJCwhm5N1pF9xs=";
  };

  buildInputs = [ attr zlib libburn libisofs ];
  propagatedBuildInputs = [ acl ];

  meta = with lib; {
    homepage = "http://libburnia-project.org/";
    description = "Enables creation and expansion of ISO-9660 filesystems on CD/DVD/BD ";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; linux;
  };
}
