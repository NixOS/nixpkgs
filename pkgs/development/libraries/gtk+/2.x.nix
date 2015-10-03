{ stdenv, fetchurl, pkgconfig, gettext, glib, atk, pango, cairo, perl, xorg
, gdk_pixbuf, libintlOrEmpty, xlibsWrapper
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? true, cups ? null
}:

assert xineramaSupport -> xorg.libXinerama != null;
assert cupsSupport -> cups != null;

stdenv.mkDerivation rec {
  name = "gtk+-2.24.28";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/2.24/${name}.tar.xz";
    sha256 = "0mj6xn40py9r9lvzg633fal81xfwfm89d9mvz7jk4lmwk0g49imj";
  };

  outputs = [ "dev" "out" "doc" ];
  outputBin = "dev";

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (libintlOrEmpty != []) "-lintl";

  setupHook = ./setup-hook.sh;

  nativeBuildInputs = [ setupHook perl pkgconfig gettext ];

  propagatedBuildInputs = with xorg; with stdenv.lib;
    [ glib cairo pango gdk_pixbuf atk ]
    ++ optionals (stdenv.isLinux || stdenv.isDarwin) [
         libXrandr libXrender libXcomposite libXi libXcursor
       ]
    ++ optionals stdenv.isDarwin [ xlibsWrapper libXdamage ]
    ++ libintlOrEmpty
    ++ optional xineramaSupport libXinerama
    ++ optionals cupsSupport [ cups ];

  configureFlags = if stdenv.isDarwin
    then "--disable-glibtest --disable-introspection --disable-visibility"
    else "--with-xinput=yes";

  postInstall = ''
    _moveToOutput share/gtk-2.0/demo "$doc"
  '';

  passthru = {
    gtkExeEnvPostBuild = ''
      rm $out/lib/gtk-2.0/2.10.0/immodules.cache
      $out/bin/gtk-query-immodules-2.0 $out/lib/gtk-2.0/2.10.0/immodules/*.so > $out/lib/gtk-2.0/2.10.0/immodules.cache
    ''; # workaround for bug of nix-mode for Emacs */ '';
  };

  meta = with stdenv.lib; {
    description = "A multi-platform toolkit for creating graphical user interfaces";
    homepage    = http://www.gtk.org/;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 raskin ];
    platforms   = platforms.all;

    longDescription = ''
      GTK+ is a highly usable, feature rich toolkit for creating
      graphical user interfaces which boasts cross platform
      compatibility and an easy to use API.  GTK+ it is written in C,
      but has bindings to many other popular programming languages
      such as C++, Python and C# among others.  GTK+ is licensed
      under the GNU LGPL 2.1 allowing development of both free and
      proprietary software with GTK+ without any license fees or
      royalties.
    '';
  };
}
