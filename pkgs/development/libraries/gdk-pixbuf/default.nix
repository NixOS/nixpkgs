{ stdenv, fetchurl, pkgconfig, glib, libtiff, libjpeg, libpng, libX11
, jasper, libintlOrEmpty, gobjectIntrospection, doCheck ? false }:

let
  ver_maj = "2.34";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "gdk-pixbuf-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/${ver_maj}/${name}.tar.xz";
    sha256 = "0yc8indbl3hf18z6x6kjg59xp9sngm1d8vmz4c7bs6g27qw5npnm";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 gobjectIntrospection ] ++ libintlOrEmpty;

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ glib libtiff libjpeg libpng jasper ];

  # on darwin, tests don't link
  preBuild = stdenv.lib.optionalString (stdenv.isDarwin && !doCheck) ''
    substituteInPlace Makefile --replace "docs tests" "docs"
  '';

  configureFlags = "--with-libjasper --with-x11"
    + stdenv.lib.optionalString (gobjectIntrospection != null) " --enable-introspection=yes"
    ;

  # The tests take an excessive amount of time (> 1.5 hours) and memory (> 6 GB).
  inherit (doCheck);

  meta = with stdenv.lib; {
    description = "A library for image loading and manipulation";
    homepage = http://library.gnome.org/devel/gdk-pixbuf/;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.unix;
  };
}

