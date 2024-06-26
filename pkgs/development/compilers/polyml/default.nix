{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gmp,
  libffi,
}:

stdenv.mkDerivation rec {
  pname = "polyml";
  version = "5.9.1";

  src = fetchFromGitHub {
    owner = "polyml";
    repo = "polyml";
    rev = "v${version}";
    sha256 = "sha256-72wm8dt+Id59A5058mVE5P9TkXW5/LZRthZoxUustVA=";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure.ac --replace stdc++ c++
  '';

  buildInputs = [
    libffi
    gmp
  ];

  nativeBuildInputs = lib.optional stdenv.isDarwin autoreconfHook;

  configureFlags = [
    "--enable-shared"
    "--with-system-libffi"
    "--with-gmp"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    make check
    runHook postCheck
  '';

  meta = with lib; {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = "https://www.polyml.org/";
    license = licenses.lgpl21;
    platforms = with platforms; (linux ++ darwin);
    maintainers = with maintainers; [
      maggesi
      kovirobi
    ];
  };
}
