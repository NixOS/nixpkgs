{ stdenv, fetchFromGitHub, autoreconfHook, gmp, libffi }:

stdenv.mkDerivation rec {
  name = "polyml-${version}";
  version = "5.8";

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure.ac --replace stdc++ c++
  '';

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
    sha256 = "1s7q77bivppxa4vd7gxjj5dbh66qnirfxnkzh1ql69rfx1c057n3";
  };

  meta = with stdenv.lib; {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = https://www.polyml.org/;
    license = licenses.lgpl21;
    platforms = with platforms; (linux ++ darwin);
    maintainers = with maintainers; [ z77z yurrriq ];
  };
}
