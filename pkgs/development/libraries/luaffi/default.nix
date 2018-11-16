{ stdenv, fetchFromGitHub, lua, pkgconfig }:

stdenv.mkDerivation {
  name = "luaffi-2013-11-08";
  src = fetchFromGitHub {
    owner = "jmckaskill";
    repo = "luaffi";
    rev = "abc638c9341025580099dcf77795c4b320ba0e63";
    sha256 = "1hv1y9i66p473hfy36nqj220sfrxdmbd75c1gpjvpk8073vx55ac";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lua ];

  patches = [ ./darwin.patch ./makefile-errors.patch ];

  makeFlags = [ "PREFIX=$(out)" ];

  installPhase = ''
    mkdir -p $out/lib
    cp ffi.so $out/lib/ffi.so
  '';

  meta = with stdenv.lib; {
    description = "Standalone FFI library for calling C functions from lua. Compatible with the luajit FFI interface.";
    homepage = https://github.com/jmckaskill/luaffi;
    maintainers = with maintainers; [ ma27 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
