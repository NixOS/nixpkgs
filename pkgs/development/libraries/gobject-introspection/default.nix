{ stdenv, fetchurl, glib, flex, bison, meson, ninja, pkgconfig, libffi, python3
, libintl, cctools, cairo, gnome3, glibcLocales, fetchpatch
, substituteAll, nixStoreDir ? builtins.storeDir
, x11Support ? true
}:
# now that gobjectIntrospection creates large .gir files (eg gtk3 case)
# it may be worth thinking about using multiple derivation outputs
# In that case its about 6MB which could be separated

let
  pname = "gobject-introspection";
  version = "1.58.0";
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1v01wh9qagfvgq5br96bpja3w1274mvrgs0w92jy17bl6855kh97";
  };

  outputs = [ "out" "dev" "man" ];
  outputBin = "dev";

  LC_ALL = "en_US.UTF-8"; # for tests

  nativeBuildInputs = [ meson ninja pkgconfig libintl glibcLocales ];
  buildInputs = [ flex bison python3 setupHook/*move .gir*/ ]
    ++ stdenv.lib.optional stdenv.isDarwin cctools;
  propagatedBuildInputs = [ libffi glib ];

  mesonFlags = [
    "--datadir=${placeholder "dev"}/share"
  ];

  # outputs TODO: share/gobject-introspection-1.0/tests is needed during build
  # by pygobject3 (and maybe others), but it's only searched in $out

  setupHook = ./setup-hook.sh;

  patches = [
    # Prevent scanner from erroneously including @rpath on macOS
    # This patch is from https://gitlab.gnome.org/GNOME/gobject-introspection/issues/222
    # See also https://github.com/NixOS/nixpkgs/issues/40599
    ./macos-absolutize-relocatable-install-name.patch

    (substituteAll {
      src = ./absolute_shlib_path.patch;
      inherit nixStoreDir;
    })
    # Needed by gjs
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gobject-introspection/commit/a68cfd769904c621fb2ebc0c4f24f2659fa283de.patch;
      sha256 = "0f7shwvjxzrphblb6avncn1fnz956qjhqmpfifgn09bix81s43fv";
    })
  ] ++ stdenv.lib.optional x11Support # https://github.com/NixOS/nixpkgs/issues/34080
    (substituteAll {
      src = ./absolute_gir_path.patch;
      cairoLib = "${getLib cairo}/lib";
    });

  doCheck = true;

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
    license = with licenses; [ gpl2 lgpl2 ];

    longDescription = ''
      GObject introspection is a middleware layer between C libraries (using
      GObject) and language bindings. The C library can be scanned at compile
      time and generate a metadata file, in addition to the actual native C
      library. Then at runtime, language bindings can read this metadata and
      automatically provide bindings to call into the C library.
    '';
  };
}
