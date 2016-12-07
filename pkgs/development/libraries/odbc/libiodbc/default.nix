{ stdenv, fetchurl, pkgconfig, gtk2, useGTK ? false }:

stdenv.mkDerivation rec {
  name = "libiodbc-3.52.8";

  src = fetchurl {
    url = "mirror://sourceforge/iodbc/${name}.tar.gz";
    sha256 = "16hjb6fcval85gnkgkxfhw4c5h3pgf86awyh8p2bhnnvzc0ma5hq";
  };

  buildInputs = stdenv.lib.optionals useGTK [ gtk2 pkgconfig ];

  preBuild =
    ''
      export NIX_LDFLAGS_BEFORE="-rpath $out/lib"
    '';

  postInstall = ''
    pushd $out/lib
    # we check whether upstream has already moved to linking
    # libiodbcinst.so to libodbcinst.so
    # --- START SECTION
    if [ -e libodbcinst.so ]; then
      1>2 echo "upstream has linked libodbcinst.so, please remove in the build"
      exit 1
    fi
    ORIG=$(readlink libiodbcinst.so)
    echo "$ORIG"
    VER=$(echo "$ORIG" | grep -Po "(\d+.)+$")
    VER1=$(echo "$VER" | grep -Po "^\d+")

    ln -s "$ORIG" libodbcinst.so
    ln -s "$ORIG" "libodbcinst.so.$VER"
    ln -s "$ORIG" "libodbcinst.so.$VER1"
    popd
    # --- END SECTION
  '';

  meta = {
    description = "iODBC driver manager";
    homepage = http://www.iodbc.org;
    platforms = stdenv.lib.platforms.linux;
  };
}
