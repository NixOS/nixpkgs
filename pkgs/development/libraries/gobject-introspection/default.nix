{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python
, libintlOrEmpty, cctools, cairo, gnome3
, substituteAll, nixStoreDir ? builtins.storeDir
}:
# now that gobjectIntrospection creates large .gir files (eg gtk3 case)
# it may be worth thinking about using multiple derivation outputs
# In that case its about 6MB which could be separated

let
  pname = "gobject-introspection";
  version = "1.54.1";
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0zl7pfkzkm07733391b4f3cwjbnvb1nwvpmajf5bajh6bxgfv3dq";
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

  patches = [
    (substituteAll {
      src = ./absolute_shlib_path.patch;
      inherit nixStoreDir;
    })
    # https://github.com/NixOS/nixpkgs/issues/34080
    (substituteAll {
      src = ./absolute_gir_path.patch;
      cairoLib = "${getLib cairo}/lib";
    })
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gobjectIntrospection";
    };
  };

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
