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
, pkg-config
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

stdenv.mkDerivation rec {
  pname = "liblinphone";
  version = "4.4.15";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "16a31c0n5lix4r5xk7p447xlxbrhdlmj11kb4y1krb5fx8hf65cl";
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
    doxygen
    graphviz
    intltool
    makeWrapper
    pkg-config
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
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
