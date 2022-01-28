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
, ffmpeg
, gdk-pixbuf
, glib
, graphviz
, gtk2
, intltool
, jsoncpp
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
, openldap
, ortp
, pango
, pkg-config
, python3
, readline
, bc-soci
, boost
, speex
, sqlite
, lib
, stdenv
, udev
, xercesc
, xsd
, zlib
}:

stdenv.mkDerivation rec {
  pname = "liblinphone";
  version = "5.1.22";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-hTyp/fUA1+7J1MtqX33kH8Vn1XNjx51Wy5REvrpdJTY=";
  };

  patches = [ ./use-normal-jsoncpp.patch ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  # TODO: Not sure if all these inputs are actually needed. Most of them were
  # defined when liblinphone and linphone-desktop weren't separated yet, so some
  # of them might not be needed for liblinphone alone.
  buildInputs = [
    (python3.withPackages (ps: [ ps.pystache ps.six ]))

    # Made by BC
    bcg729
    bctoolbox
    belcard
    belle-sip
    belr
    bzrtp
    lime
    mediastreamer
    ortp

    # Vendored by BC
    bc-soci

    # Vendored by BC but we use upstream, might cause problems
    libmatroska

    cairo
    cyrus_sasl
    ffmpeg
    gdk-pixbuf
    glib
    gtk2
    libX11
    libexosip
    libnotify
    libosip
    libsoup
    libupnp
    libxml2
    mbedtls
    openldap
    pango
    readline
    boost
    speex
    sqlite
    udev
    xercesc
    xsd
    zlib
    jsoncpp
  ];

  nativeBuildInputs = [
    # Made by BC
    bcunit

    cmake
    doxygen
    graphviz
    intltool
    makeWrapper
    pkg-config
  ];

  strictDeps = true;

  # Some grammar files needed to be copied too from some dependencies. I suppose
  # if one define a dependency in such a way that its share directory is found,
  # then this copying would be unnecessary. Instead of actually copying these
  # files, create a symlink.
  postInstall = ''
    mkdir -p $out/share/belr/grammars
    ln -s ${belcard}/share/belr/grammars/* $out/share/belr/grammars/
  '';

  meta = with lib; {
    homepage = "https://www.linphone.org/technical-corner/liblinphone";
    description = "Library for SIP calls and instant messaging";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
