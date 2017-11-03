{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libburn-${version}";
  version = "1.4.6";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${name}.tar.gz";
    sha256 = "0wbh49s3az3sfpai09z1zdgynq7wnwrk31v5589033274nmzldlx";
  };

  meta = with stdenv.lib; {
    homepage = http://libburnia-project.org/;
    description = "A library by which preformatted data get onto optical media: CD, DVD, BD (Blu-Ray)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar vrthra ];
    platforms = with platforms; unix;
  };
}
