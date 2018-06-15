{ stdenv, fetchurl, acl, attr, zlib, libburn, libisofs }:

stdenv.mkDerivation rec {
  name = "libisoburn-${version}";
  version = "1.4.8";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${name}.tar.gz";
    sha256 = "19d53j17pn18vfxxqqlqwam5lm21ljyp8nai5434068g7x3m1kwi";
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
