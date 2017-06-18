{ stdenv, fetchFromGitHub, autoreconfHook, gmp, libffi }:

stdenv.mkDerivation rec {
  name = "polyml-${version}";
  version = "5.7";

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
    sha256 = "10nsljmcl0zjbcc7ifc991ypwfwq5gh4rcp5rg4nnb706c6bs16y";
  };

  meta = with stdenv.lib; {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = http://www.polyml.org/;
    license = licenses.lgpl21;
    platforms = with platforms; (linux ++ darwin);
    maintainers = with maintainers; [ z77z yurrriq ];
  };
}
