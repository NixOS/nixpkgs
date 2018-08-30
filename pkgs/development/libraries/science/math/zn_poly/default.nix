{ stdenv
, fetchurl
, gmp
, python2
}:

stdenv.mkDerivation rec {
  version = "0.9";
  pname = "zn_poly";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://web.maths.unsw.edu.au/~davidharvey/code/zn_poly/releases/zn_poly-${version}.tar.gz";
    sha256 = "1kxl25av7i3v68k32hw5bayrfcvmahmqvs97mlh9g238gj4qb851";
  };

  buildInputs = [
    gmp
  ];

  nativeBuildInputs = [
    python2 # needed by ./configure to create the makefile
  ];

  libname = "libzn_poly${stdenv.targetPlatform.extensions.sharedLibrary}";

  makeFlags = [ "CC=cc" ];

  # Tuning (either autotuning or with hand-written paramters) is possible
  # but not implemented here.
  # It seems buggy anyways (see homepage).
  buildFlags = [ "all" libname ];


  # `make install` fails to install some header files and the lib file.
  installPhase = ''
    mkdir -p "$out/include/zn_poly"
    mkdir -p "$out/lib"
    cp "${libname}" "$out/lib"
    cp include/*.h "$out/include/zn_poly"
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://web.maths.unsw.edu.au/~davidharvey/code/zn_poly/;
    description = "Polynomial arithmetic over Z/nZ";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.unix;
  };
}
