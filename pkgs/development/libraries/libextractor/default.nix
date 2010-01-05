{ fetchurl, stdenv, libtool, gettext, zlib, bzip2, flac, libvorbis, libmpeg2
, ffmpeg, exiv2, libgsf, rpm, pkgconfig, glib, gtk }:

stdenv.mkDerivation rec {
  name = "libextractor-0.5.23";

  src = fetchurl {
    url = "mirror://gnu/libextractor/${name}.tar.gz";
    sha256 = "1zyfshayjrp7kd87pm7blyq0dvbv5bbh3f368pp4jws4qxs8aj9f";
  };

  preConfigure =
    '' echo "patching installation directory in \`extractor.c'..."
       sed -i "src/main/extractor.c" \
           -e "s|pexe[[:blank:]]*=.*$|pexe = strdup(\"$out/lib/\");|g"
    '';

  buildInputs =
   [ libtool gettext zlib bzip2 flac libvorbis libmpeg2 exiv2 ffmpeg
     libgsf rpm
     pkgconfig glib gtk
   ];

  configureFlags = "--disable-ltdl-install "
    + "--with-ltdl-include=${libtool}/include "
    + "--with-ltdl-lib=${libtool}/lib "
    + "--enable-xpdf";

  # Checks need to be run after "make install", otherwise plug-ins are not in
  # the search path, etc.
  # FIXME: Tests currently fail and the test framework appears to be deeply
  # broken anyway.
  doCheck = false;
  #postInstall = "make check";

  meta = {
    description = "GNU libextractor, a simple library for keyword extraction";

    longDescription =
      '' GNU libextractor is a library used to extract meta-data from files
         of arbitrary type.  It is designed to use helper-libraries to perform
         the actual extraction, and to be trivially extendable by linking
         against external extractors for additional file types.

         The goal is to provide developers of file-sharing networks or
         WWW-indexing bots with a universal library to obtain simple keywords
         to match against queries.  libextractor contains a shell-command
         extract that, similar to the well-known file command, can extract
         meta-data from a file an print the results to stdout.

         Currently, libextractor supports the following formats: HTML, PDF,
         PS, OLE2 (DOC, XLS, PPT), OpenOffice (sxw), StarOffice (sdw), DVI,
         MAN, FLAC, MP3 (ID3v1 and ID3v2), NSF(E) (NES music), SID (C64
         music), OGG, WAV, EXIV2, JPEG, GIF, PNG, TIFF, DEB, RPM, TAR(.GZ),
         ZIP, ELF, S3M (Scream Tracker 3), XM (eXtended Module), IT (Impulse
         Tracker), FLV, REAL, RIFF (AVI), MPEG, QT and ASF.  Also, various
         additional MIME types are detected.
      '';

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
