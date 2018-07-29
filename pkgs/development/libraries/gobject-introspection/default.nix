{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python
, libintl, cctools, cairo, gnome3
, substituteAll, nixStoreDir ? builtins.storeDir
, x11Support ? true
# remove these after the next upstream release:
, runCommand, patchutils, autoreconfHook
}:
# now that gobjectIntrospection creates large .gir files (eg gtk3 case)
# it may be worth thinking about using multiple derivation outputs
# In that case its about 6MB which could be separated

let
  pname = "gobject-introspection";
  version = "1.56.0";
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1y50pbn5qqbcv2h9rkz96wvv5jls2gma9bkqjq6wapmaszx5jw0d";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";
  outputMan = "dev"; # tiny pages

  # autoreconfHook is only required with upstream patch a41abe1, which touches
  # a Makefile.am. It can be removed along with the patch below after the next
  # upstream release.
  nativeBuildInputs = [ autoreconfHook pkgconfig libintl ];
  buildInputs = [ flex bison python setupHook/*move .gir*/ ]
    ++ stdenv.lib.optional stdenv.isDarwin cctools;
  propagatedBuildInputs = [ libffi glib ];

  preConfigure = ''
    sed 's|/usr/bin/env ||' -i tools/g-ir-tool-template.in
  '';

  # outputs TODO: share/gobject-introspection-1.0/tests is needed during build
  # by pygobject3 (and maybe others), but it's only searched in $out

  setupHook = ./setup-hook.sh;

  patches = [
    # backport upstream patch a41abe1 to 1.56.*, which didn't use Meson
    # https://gitlab.gnome.org/GNOME/gobject-introspection/commit/a41abe1868a693387cd5cf85567cf2e0fd6c62df
    (runCommand "parse-ldd-output.patch" { } ''
      ${patchutils}/bin/filterdiff --clean --exclude="*/meson.build" ${fetchurl {
        url = "https://gitlab.gnome.org/GNOME/gobject-introspection/commit/a41abe1868a693387cd5cf85567cf2e0fd6c62df.diff";
        sha256 = "0b3ighkr3gyhhvbm2vhipgdlcx7yvxrrf0kqgl182h8k6ygn5ydv";
      }} > $out
    '')
  ] ++ stdenv.lib.optional x11Support # https://github.com/NixOS/nixpkgs/issues/34080
    (substituteAll {
      src = ./absolute_gir_path.patch;
      cairoLib = "${getLib cairo}/lib";
    });

  doCheck = false; # fails

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
