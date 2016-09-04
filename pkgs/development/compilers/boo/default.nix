{ stdenv, fetchFromGitHub, pkgconfig, dbus, mono, makeWrapper, nant
, shared_mime_info, gtksourceview, gtk
, targetVersion ? "4.5" }:

let
  release = "alpha";
in stdenv.mkDerivation rec {
  name = "boo-${version}";
  version = "2013-10-21";

  src = fetchFromGitHub {
    owner = "boo-lang";
    repo = "boo";

    rev = "${release}";
    sha256 = "174abdwfpq8i3ijx6bwqll16lx7xwici374rgsbymyk8g8mla094";
  };

  buildInputs = [
    pkgconfig mono makeWrapper nant shared_mime_info gtksourceview
    gtk
  ];

  patches = [ ./config.patch ];

  postPatch = ''
    sed -e 's|\$out|'$out'|' -i default.build
  '';

  buildPhase = ''
    nant -t:mono-4.5
  '';

  installPhase = ''
    nant install
    cp $out/lib/mono/boo/*.dll $out/lib/boo/
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "The Boo Programming Language";
    platforms = platforms.linux;
    broken = true;
  };
}
