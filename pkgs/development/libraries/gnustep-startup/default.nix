{ stdenv, fetchurl, pkgconfig
, aspell
, cups
, audiofile, portaudio
, clang, libobjc2
, libjpeg, libtiff, libpng, giflib, libungif
, libxml2, libxslt, libiconv
, libffi
, gnutls, libgcrypt
, icu
, xlibs, x11
, freetype
, which
}:

let
  version = "0.32.0";
in
stdenv.mkDerivation rec {
  name = "gnustep-core-${version}";

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-startup-${version}.tar.gz";
    sha256 = "1f24lggaind43jhp6gy5zspljbha5l2gnys1ddxjdxkiwqfkznc6";
  };

  buildInputs = [ clang libobjc2 cups audiofile portaudio aspell libjpeg libtiff libpng giflib libungif libxml2 libxslt libiconv gnutls libgcrypt icu pkgconfig x11 libffi freetype which ];
  # TODO: what's this for?
#  nativeBuildInputs = [ ];
# propagatedBuildInputs = [ ];

  buildPhase = ''
    ./InstallGNUstep --batch --prefix=$out
  '';

  # TODO: add:
  # . $out/System/Library/Makefiles/GNUstep.sh
  # to bashrc prior to building any GNUstep package
  # TODO: could simply make the installPhase = "";
  installPhase = ''
    echo Do not forget to source $out/System/Library/Makefiles/GNUstep.sh!
  '';

  meta = {
    description = "GNUstep is a free, object-oriented, cross-platform development environment that strives for simplicity and elegance. GNUstep is based on and strives to be completely compatible with the Cocoa specification developed by Apple (Previously NeXT Software, Inc.).";

    longDescription = ''
      GNUstep is...

      ...an object-oriented tool development kit

      GNUstep-make and GNUstep-base make up the core libraries contain
      a complete system for writing non-graphic tools in Objective-C. The
      make package allows you to setup a simple and powerful system for
      building, installing and packaging your tools. The base package
      includes all the classes necessary for writing an incredible array of
      tools, from wrappers for system tools to tools for communicating with
      web and other types of servers.

      ...and a graphical development kit

      The core libraries contain classes for developing a complete
      graphical application for almost any purpose. Along with our
      object-oriented, graphical development applications,
      ProjectCenter and Gorm it's simple to write very complex
      commercial applications in weeks or months, rather than years
      (or often, never) in the case of other development environments.
      
      ...and a cross platform development environment

      GNUstep can, currently, allow you to build applications on
      GNU/Linux, Windows, FreeBSD, OpenBSD, NetBSD, Solaris and any
      POSIX compliant UNIX based operating system.
    '';

    homepage = http://gnustep.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.all;
  };
}
