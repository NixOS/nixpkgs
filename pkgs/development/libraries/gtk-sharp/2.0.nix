{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, mono
, glib
, pango
, gtk2
, libxml2
, monoDLLFixer
, autoconf
, automake
, libtool
, which
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "gtk-sharp";
  version = "2.12.45";

  builder = ./builder.sh;
  src = fetchFromGitHub {
    owner = "mono";
    repo = "gtk-sharp";
    rev = version;
    sha256 = "1vy6yfwkfv6bb45bzf4g6dayiqkvqqvlr02rsnhd10793hlpqlgg";
  };

  patches = [
    (fetchpatch {
      url = "https://projects.archlinux.de/svntogit/packages.git/plain/trunk/gtk-sharp2-2.12.12-gtkrange.patch?h=packages/gtk-sharp-2";
      sha256 = "bjx+OfgWnN8SO82p8G7pbGuxJ9EeQxMLeHnrtEm8RV8=";
    })
  ];

  postInstall = ''
    pushd $out/bin
    for f in gapi2-*
    do
      substituteInPlace $f --replace mono ${mono}/bin/mono
    done
    popd
  '';

  nativeBuildInputs = [ pkg-config autoconf automake libtool which ];

  buildInputs = [
    mono glib pango gtk2
    libxml2
  ];

  preConfigure = ''
    ./bootstrap-${lib.versions.majorMinor version}
  '';

  dontStrip = true;

  inherit monoDLLFixer;

  passthru = {
    gtk = gtk2;
  };

  meta = with lib; {
    description = "Graphical User Interface Toolkit for mono and .Net";
    homepage = "https://www.mono-project.com/docs/gui/gtksharp";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
