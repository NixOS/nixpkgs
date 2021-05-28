{ bcg729
, bctoolbox
, bcunit
, belcard
, belle-sip
, belr
, bzrtp
, cairo
, cmake
, cyrus_sasl
, doxygen
, fetchFromGitLab
, fetchurl
, ffmpeg_3
, gdk-pixbuf
, git
, glib
, graphviz
, gtk2
, intltool
, libexosip
, libmatroska
, libnotify
, libosip
, libsoup
, libupnp
, libX11
, libxml2
, lime
, makeWrapper
, mbedtls
, mediastreamer
, mediastreamer-openh264
, openldap
, ortp
, pango
, pkgconfig
, python
, readline
, soci
, speex
, sqlite
, stdenv
, udev
, xercesc
, xsd
, zlib
}:
let
  # Got the following error when building:
  #
  #   Your version of Doxygen (1.8.17) is known to malfunction with some of our
  #   macro definitions, which causes errors while wrapprers generation. Please
  #   install an older version of Doxygen (< 1.8.17) or disable documentation
  #   and wrapper generation.
  #
  # So, let's then use 1.8.16 version of doxygen in this derivation. Hopefully
  # this workaround can be removed with some newer release of liblinphone.
  doxygen_1_8_16 = doxygen.overrideAttrs (
    oldAttrs: rec {
      name = "doxygen-1.8.16";
      src = fetchurl {
        urls = [
          "mirror://sourceforge/doxygen/${name}.src.tar.gz" # faster, with https, etc.
          "http://doxygen.nl/files/${name}.src.tar.gz"
        ];
        sha256 = "10iwv8bcz5b5cd85gg8pgn0bmyg04n9hs36xn7ggjjnvynv1z67z";
      };
      buildInputs = oldAttrs.buildInputs ++ [ git ];
    }
  );
in
stdenv.mkDerivation rec {
  pname = "liblinphone";
  # Using master branch for linphone-desktop caused a chain reaction that many
  # of its dependencies needed to use master branch too.
  version = "unstable-2020-03-20";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "1d762a3e0e304aa579798aed4400d2cee2c1ffa0";
    sha256 = "0ja38payyqbd8z6q5l5w6hi7xarmfj5021gh0qdk0j832br4c6c3";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  # TODO: Not sure if all these inputs are actually needed. Most of them were
  # defined when liblinphone and linphone-desktop weren't separated yet, so some
  # of them might not be needed for liblinphone alone.
  buildInputs = [
    (python.withPackages (ps: [ ps.pystache ps.six ]))
    bcg729
    bctoolbox
    belcard
    belle-sip
    belr
    bzrtp
    cairo
    cyrus_sasl
    ffmpeg_3
    gdk-pixbuf
    git
    glib
    gtk2
    libX11
    libexosip
    libmatroska
    libnotify
    libosip
    libsoup
    libupnp
    libxml2
    lime
    mbedtls
    mediastreamer
    openldap
    ortp
    pango
    readline
    soci
    speex
    sqlite
    udev
    xercesc
    xsd
    zlib
  ];

  nativeBuildInputs = [
    bcunit
    cmake
    doxygen_1_8_16
    graphviz
    intltool
    makeWrapper
    pkgconfig
  ];

  # Some grammar files needed to be copied too from some dependencies. I suppose
  # if one define a dependency in such a way that its share directory is found,
  # then this copying would be unnecessary. Instead of actually copying these
  # files, create a symlink.
  postInstall = ''
    mkdir -p $out/share/belr/grammars
    ln -s ${belcard}/share/belr/grammars/* $out/share/belr/grammars/
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.linphone.org/technical-corner/liblinphone";
    description = "Library for SIP calls and instant messaging";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
