{ stdenv, fetchFromGitHub, autoreconfHook, gmp, libffi }:

stdenv.mkDerivation rec {
  pname = "polyml";
  version = "5.7.1";

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure.ac --replace stdc++ c++
  '';

  patches = [ ./5.7-new-libffi-FFI_SYSV.patch ];

  buildInputs = [ libffi gmp ];

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin autoreconfHook;

  configureFlags = [
    "--enable-shared"
    "--with-system-libffi"
    "--with-gmp"
  ];

  src = fetchFromGitHub {
    owner = "polyml";
    repo = "polyml";
    rev = "v${version}";
    sha256 = "0j0wv3ijfrjkfngy7dswm4k1dchk3jak9chl5735dl8yrl8mq755";
  };

  meta = with stdenv.lib; {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = https://www.polyml.org/;
    license = licenses.lgpl21;
    platforms = with platforms; (linux ++ darwin);
    maintainers = with maintainers; [ maggesi ];
  };
}
