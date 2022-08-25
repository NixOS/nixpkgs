{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "libstemmer";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "snowball";
    rev = "v${version}";
    sha256 = "sha256-qXrypwv/I+5npvGHGsHveijoui0ZnoGYhskCfLkewVE=";
  };

  nativeBuildInputs = [ perl ];

  prePatch = ''
    patchShebangs .
  '';

  makeTarget = "libstemmer.a";

  installPhase = ''
    runHook preInstall
    install -Dt $out/lib libstemmer.a
    install -Dt $out/include include/libstemmer.h
    runHook postInstall
  '';

  meta = with lib; {
    description = "Snowball Stemming Algorithms";
    homepage = "https://snowballstem.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
  };
}
