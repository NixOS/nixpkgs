{ stdenv, fetchurl, pkgconfig, glib, libtiff, libjpeg, libpng, libX11
, jasper, libintlOrEmpty, gobjectIntrospection, doCheck ? false }:

let
  ver_maj = "2.36";
  ver_min = "6";
in
stdenv.mkDerivation rec {
  name = "gdk-pixbuf-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/${ver_maj}/${name}.tar.xz";
    sha256 = "455eb90c09ed1b71f95f3ebfe1c904c206727e0eeb34fc94e5aaf944663a820c";
  };

  outputs = [ "out" "dev" "devdoc" ];

  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 gobjectIntrospection ] ++ libintlOrEmpty;

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ glib libtiff libjpeg libpng jasper ];

  configureFlags = "--with-libjasper --with-x11"
    + stdenv.lib.optionalString (gobjectIntrospection != null) " --enable-introspection=yes"
    ;

  # on darwin, tests don't link
  preBuild = stdenv.lib.optionalString (stdenv.isDarwin && !doCheck) ''
    substituteInPlace Makefile --replace "docs tests" "docs"
  '';

  postInstall =
    # All except one utility seem to be only useful during building.
    ''
      moveToOutput "bin" "$dev"
      moveToOutput "bin/gdk-pixbuf-thumbnailer" "$out"
    '';

  # The tests take an excessive amount of time (> 1.5 hours) and memory (> 6 GB).
  inherit (doCheck);

  meta = with stdenv.lib; {
    description = "A library for image loading and manipulation";
    homepage = http://library.gnome.org/devel/gdk-pixbuf/;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.unix;
  };
}

