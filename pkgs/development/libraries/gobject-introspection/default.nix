{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python
, libintlOrEmpty, autoconf, automake, otool }:
# now that gobjectIntrospection creates large .gir files (eg gtk3 case)
# it may be worth thinking about using multiple derivation outputs
# In that case its about 6MB which could be separated

let
  ver_maj = "1.38";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "gobject-introspection-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gobject-introspection/${ver_maj}/${name}.tar.xz";
    sha256 = "0wvxyvgajmms2bb6k3pf1rdpnd79xdxamykzvxzmcyn1ag9yax9m";
  };

  buildInputs = [ flex bison glib pkgconfig python ]
    ++ libintlOrEmpty
    ++ stdenv.lib.optional stdenv.isDarwin otool;
  propagatedBuildInputs = [ libffi ];

  # Tests depend on cairo, which is undesirable (it pulls in lots of
  # other dependencies).
  configureFlags = [ "--disable-tests" ];

  postInstall = "rm -rf $out/share/gtk-doc";

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "A middleware layer between C libraries and language bindings";
    homepage    = http://live.gnome.org/GObjectIntrospection;
    maintainers = with maintainers; [ lovek323 urkud ];
    platforms   = platforms.unix;

    longDescription = ''
      GObject introspection is a middleware layer between C libraries (using
      GObject) and language bindings. The C library can be scanned at compile
      time and generate a metadata file, in addition to the actual native C
      library. Then at runtime, language bindings can read this metadata and
      automatically provide bindings to call into the C library.
    '';
  };
}
