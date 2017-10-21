{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python
, libintlOrEmpty, cctools
, substituteAll, nixStoreDir ? builtins.storeDir
}:
# now that gobjectIntrospection creates large .gir files (eg gtk3 case)
# it may be worth thinking about using multiple derivation outputs
# In that case its about 6MB which could be separated

let
  ver_maj = "1.52";
  ver_min = "1";
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "gobject-introspection-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gobject-introspection/${ver_maj}/${name}.tar.xz";
    sha256 = "1x5gkyrglv3dn9b4fsgw6asqgjw1wj7qc37g9pyac6pyaa6w7l1f";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";
  outputMan = "dev"; # tiny pages

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ flex bison python setupHook/*move .gir*/ ]
    ++ libintlOrEmpty
    ++ stdenv.lib.optional stdenv.isDarwin cctools;
  propagatedBuildInputs = [ libffi glib ];

  preConfigure = ''
    sed 's|/usr/bin/env ||' -i tools/g-ir-tool-template.in
  '';

  # outputs TODO: share/gobject-introspection-1.0/tests is needed during build
  # by pygobject3 (and maybe others), but it's only searched in $out

  setupHook = ./setup-hook.sh;

  patches = stdenv.lib.singleton (substituteAll {
    src = ./absolute_shlib_path.patch;
    inherit nixStoreDir;
  });

  meta = with stdenv.lib; {
    description = "A middleware layer between C libraries and language bindings";
    homepage    = http://live.gnome.org/GObjectIntrospection;
    maintainers = with maintainers; [ lovek323 lethalman ];
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
