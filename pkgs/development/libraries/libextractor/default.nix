{ lib, stdenv, fetchurl, fetchpatch, substituteAll
, libtool, gettext, zlib, bzip2, flac, libvorbis
, exiv2, libgsf, pkg-config
, rpmSupport ? stdenv.isLinux, rpm
, gstreamerSupport ? true, gst_all_1
# ^ Needed e.g. for proper id3 and FLAC support.
#   Set to `false` to decrease package closure size by about 87 MB (53%).
, gstPlugins ? (gst: [ gst.gst-plugins-base gst.gst-plugins-good ])
# If an application needs additional gstreamer plugins it can also make them
# available by adding them to the environment variable
# GST_PLUGIN_SYSTEM_PATH_1_0, e.g. like this:
# postInstall = ''
#   wrapProgram $out/bin/extract --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
# '';
# See also <https://nixos.org/nixpkgs/manual/#sec-language-gnome>.
, gtkSupport ? true, glib, gtk3
, videoSupport ? true, ffmpeg_4, libmpeg2
}:

stdenv.mkDerivation rec {
  pname = "libextractor";
  version = "1.11";

  src = fetchurl {
    url = "mirror://gnu/libextractor/${pname}-${version}.tar.gz";
    sha256 = "sha256-FvYzq4dGo4VHxKHaP0WRGSsIJa2DxDNvBXW4WEPYvY8=";
  };

  patches = [
    (fetchpatch {
      name = "libextractor-exiv2-0.28.patch";
      url = "https://git.pld-linux.org/?p=packages/libextractor.git;a=blob_plain;f=libextractor-exiv2-0.28.patch;h=d763b65f2578f1127713de8dc82f432d34f95a85;hb=0e7de1c6794e8c331a1a1a6a829993c7cd217d3a";
      hash = "sha256-szAv2A+NmiQyj2+R7BO6fHX588vlTgljPtrnMR6mgGY=";
    })
  ] ++ lib.optionals gstreamerSupport [

    # Libraries cannot be wrapped so we need to hardcode the plug-in paths.
    (substituteAll {
      src = ./gst-hardcode-plugins.patch;
      load_gst_plugins = lib.concatMapStrings
        (plugin: ''gst_registry_scan_path(gst_registry_get(), "${lib.getLib plugin}/lib/gstreamer-1.0");'')
        (gstPlugins gst_all_1);
    })
  ];

  preConfigure =
    '' echo "patching installation directory in \`extractor.c'..."
       sed -i "src/main/extractor.c" \
           -e "s|pexe[[:blank:]]*=.*$|pexe = strdup(\"$out/lib/\");|g"
    '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
   [ libtool gettext zlib bzip2 flac libvorbis exiv2
     libgsf
   ] ++ lib.optionals rpmSupport [ rpm ]
     ++ lib.optionals gstreamerSupport
          ([ gst_all_1.gstreamer ] ++ gstPlugins gst_all_1)
     ++ lib.optionals gtkSupport [ glib gtk3 ]
     ++ lib.optionals videoSupport [ ffmpeg_4 libmpeg2 ];

  configureFlags = [
    "--disable-ltdl-install"
    "--with-ltdl-include=${libtool}/include"
    "--with-ltdl-lib=${libtool.lib}/lib"
    "--enable-xpdf"
  ];

  # Checks need to be run after "make install", otherwise plug-ins are not in
  # the search path, etc.
  doCheck = false;
  doInstallCheck = !stdenv.isDarwin;
  installCheckPhase = "make check";

  meta = with lib; {
    description = "Simple library for keyword extraction";
    mainProgram = "extract";

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

    license = licenses.gpl3Plus;

    maintainers = [ maintainers.jorsn ];
    platforms = platforms.unix;
  };
}
