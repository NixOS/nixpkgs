{ stdenv, lib, fetchurl }:
let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
  cross = "${stdenv.hostPlatform.config}";
  static = stdenv.hostPlatform.isStatic;

  cc = if !isCross then "cc" else "${cross}-cc";
  ar = if !isCross then "ar" else "${cross}-ar";
  ranlib = if !isCross then "ranlib" else "${cross}-ranlib";
in stdenv.mkDerivation rec {
  postPatch = ''
    sed -i 's,set --, set -x; set --,' Makefile
  '';
  pname = "tinycdb";
  version = "0.80";
  # In general, static library (.a) goes to "dev", shared (.so) to
  # "lib". In case of static build, there is no .so library, so "lib"
  # output is useless and empty.
  outputs = [ "out" "dev" "man" ] ++ lib.optional (!static) "lib";
  separateDebugInfo = true;
  makeFlags =
    [ "prefix=$(out)" "CC=${cc}" "AR=${ar}" "RANLIB=${ranlib}" "static"
  ] ++ lib.optional (!static) "shared";
  postInstall = ''
    mkdir -p $dev/lib $out/bin
    mv $out/lib/libcdb.a $dev/lib
    rmdir $out/lib
  '' + (if static then ''
    cp cdb $out/bin/cdb
  '' else ''
    mkdir -p $lib/lib
    cp libcdb.so* $lib/lib
    cp cdb-shared $out/bin/cdb
  '');

  src = fetchurl {
    url = "http://www.corpit.ru/mjt/tinycdb/${pname}-${version}.tar.gz";
    sha256 = "sha256-wyG5BekCwsqZo/+Kjd39iCMkf+Ht7IpLuF+Dhpxjn7g=";
  };

  meta = with lib; {

    description = "utility to manipulate constant databases (cdb)";
    mainProgram = "cdb";

    longDescription = ''
      tinycdb is a small, fast and reliable utility and subroutine
      library for creating and reading constant databases. The database
      structure is tuned for fast reading.
    '';

    homepage = "https://www.corpit.ru/mjt/tinycdb.html";
    license = licenses.publicDomain;
    platforms = platforms.linux;
  };
}
