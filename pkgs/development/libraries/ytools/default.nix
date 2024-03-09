{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "ytools";
  version = "unstable-2021-09-13";

  src = fetchFromGitHub {
    owner = "bbuhrow";
    repo = pname;
    rev = "bf7f82d05ec9b74b3b1c0b99a734c321d7eb540c";
    sha256 = "FoUqgUi/ofkqRaUnDIxL6j2/eSX7zOma54rvP/tv1UA=";
  };

  makeFlags = [ "CC=${stdenv.cc}/bin/cc" ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/lib libytools.*
    install -Dt $out/include *.h

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/bbuhrow/ytools";
    description = "Miscellaneous common data structures and algorithms";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
