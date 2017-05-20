{ fetchurl, stdenv, libtool, gettext, zlib, bzip2, flac, libvorbis
, exiv2, libgsf, rpm, pkgconfig
, gtkSupport ? true, glib ? null, gtk3 ? null
, videoSupport ? true, ffmpeg ? null, libmpeg2 ? null}:

assert gtkSupport -> glib != null && gtk3 != null;
assert videoSupport -> ffmpeg != null && libmpeg2 != null;

stdenv.mkDerivation rec {
  name = "libextractor-1.3";

  src = fetchurl {
    url = "mirror://gnu/libextractor/${name}.tar.gz";
    sha256 = "0zvv7wd011npcx7yphw9bpgivyxz6mlp87a57n96nv85k96dd2l6";
  };

  preConfigure =
    '' echo "patching installation directory in \`extractor.c'..."
       sed -i "src/main/extractor.c" \
           -e "s|pexe[[:blank:]]*=.*$|pexe = strdup(\"$out/lib/\");|g"
    '';

  buildInputs =
   [ libtool gettext zlib bzip2 flac libvorbis exiv2
     libgsf rpm
     pkgconfig
   ] ++ stdenv.lib.optionals gtkSupport [ glib gtk3 ]
     ++ stdenv.lib.optionals videoSupport [ ffmpeg libmpeg2 ];

  configureFlags = "--disable-ltdl-install "
    + "--with-ltdl-include=${libtool}/include "
    + "--with-ltdl-lib=${libtool.lib}/lib "
    + "--enable-xpdf";

  # Checks need to be run after "make install", otherwise plug-ins are not in
  # the search path, etc.
  # FIXME: Tests currently fail and the test framework appears to be deeply
  # broken anyway.
  doCheck = false;
  #postInstall = "make check";

  meta = {
    description = "Simple library for keyword extraction";

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

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.linux;
  };
}
