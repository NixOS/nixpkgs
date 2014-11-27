{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python
, libintlOrEmpty, autoconf, automake, otool }:
# now that gobjectIntrospection creates large .gir files (eg gtk3 case)
# it may be worth thinking about using multiple derivation outputs
# In that case its about 6MB which could be separated

let
  ver_maj = "1.42";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "gobject-introspection-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gobject-introspection/${ver_maj}/${name}.tar.xz";
    sha256 = "3ba2edfad4f71d4f0de16960b5d5f2511335fa646b2c49bbb93ce5942b3f95f7";
  };

  buildInputs = [ flex bison pkgconfig python ]
    ++ libintlOrEmpty
    ++ stdenv.lib.optional stdenv.isDarwin otool;
  propagatedBuildInputs = [ libffi glib ];

  # Tests depend on cairo, which is undesirable (it pulls in lots of
  # other dependencies).
  configureFlags = [ "--disable-tests" ];

  postInstall = "rm -rf $out/share/gtk-doc";

  setupHook = ./setup-hook.sh;

  patches = [ ./absolute_shlib_path.patch ];

  meta = with stdenv.lib; {
    description = "A middleware layer between C libraries and language bindings";
    homepage    = http://live.gnome.org/GObjectIntrospection;
    maintainers = with maintainers; [ lovek323 urkud lethalman ];
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
