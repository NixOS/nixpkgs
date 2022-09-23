{ lib, stdenv, fetchurl, acl, attr, zlib, libburn, libisofs }:

stdenv.mkDerivation rec {
  pname = "libisoburn";
  version = "1.5.4";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-LYmEbUOIDxf6WRxTs76kL/uANijk5jDGgPwskYT3kTI=";
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
