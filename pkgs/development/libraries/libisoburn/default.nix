{ stdenv, fetchurl, acl, attr, zlib, libburn, libisofs }:

stdenv.mkDerivation rec {
  name = "libisoburn-${version}";
  version = "1.4.4";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${name}.tar.gz";
    sha256 = "1mn2dwkwdrdcjnd59czxali7r5nlxdx92clyxnsfpmw20f9s20kv";
  };

  buildInputs = [ attr zlib libburn libisofs ];
  propagatedBuildInputs = [ acl ];

  meta = with stdenv.lib; {
    homepage = http://libburnia-project.org/;
    description = "Enables creation and expansion of ISO-9660 filesystems on CD/DVD/BD ";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; linux;
  };
}
