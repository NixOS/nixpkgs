{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "double-conversion-1.1.5";

  src = fetchurl {
    url = "https://double-conversion.googlecode.com/files/${name}.tar.gz";
    sha256 = "0hnlyn9r8vd9b3dafnk01ykz4k7bk6xvmvslv93as1cswf7vdvqv";
  };

  unpackPhase = ''
    mkdir $name
    cd $name
    tar xzf $src
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Binary-decimal and decimal-binary routines for IEEE doubles";
    homepage = https://code.google.com/p/double-conversion/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = maintainers.abbradar;
  };
}
