{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python
, libintlOrEmpty, cctools
, substituteAll, nixStoreDir ? builtins.storeDir
}:
# now that gobjectIntrospection creates large .gir files (eg gtk3 case)
# it may be worth thinking about using multiple derivation outputs
# In that case its about 6MB which could be separated

let
  ver_maj = "1.48";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "gobject-introspection-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gobject-introspection/${ver_maj}/${name}.tar.xz";
    sha256 = "0xsqwxhfqzr79av89mg766kxpb2i41bd0vwspk01xjdzrnn5l9zs";
  };

  buildInputs = [ flex bison pkgconfig python ]
    ++ libintlOrEmpty
    ++ stdenv.lib.optional stdenv.isDarwin cctools;
  propagatedBuildInputs = [ libffi glib ];

  # The '--disable-tests' flag is no longer recognized, so can be safely removed
  # next time this package changes.
  configureFlags = [ "--disable-tests" ];

  preConfigure = ''
    sed 's|/usr/bin/env ||' -i tools/g-ir-tool-template.in
  '';

  postInstall = "rm -rf $out/share/gtk-doc";

  setupHook = ./setup-hook.sh;

  patches = stdenv.lib.singleton (substituteAll {
    src = ./absolute_shlib_path.patch;
    inherit nixStoreDir;
  });

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
