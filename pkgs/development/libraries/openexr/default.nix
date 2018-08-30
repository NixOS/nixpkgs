{ lib, stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, zlib, ilmbase }:

stdenv.mkDerivation rec {
  name = "openexr-${version}";
  version = lib.getVersion ilmbase;

  src = fetchurl {
    url = "https://github.com/openexr/openexr/releases/download/v${version}/${name}.tar.gz";
    sha256 = "19jywbs9qjvsbkvlvzayzi81s976k53wg53vw4xj66lcgylb6v7x";
  };

  patches = [
    ./bootstrap.patch
  ];

  outputs = [ "bin" "dev" "out" "doc" ];

  preConfigure = ''
    patchShebangs ./bootstrap
    ./bootstrap
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libtool ];
  propagatedBuildInputs = [ ilmbase zlib ];

  enableParallelBuilding = true;
  doCheck = false; # fails 1 of 1 tests

  meta = with stdenv.lib; {
    homepage = http://www.openexr.com/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
