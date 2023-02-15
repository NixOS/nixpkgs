{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "exprtk";
  version = "unstable-2021-12-31";

  src = fetchFromGitHub {
    owner = "ArashPartow";
    repo = "exprtk";
    rev = "806c519c91fd08ba4fa19380dbf3f6e42de9e2d1";
    hash = "sha256-5/k+y3gNJeggfwXmtAVqmaiV+BXX+WKtWwZWcQSrQDM=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 exprtk.hpp "$out/include/exprtk.hpp"
    runHook postInstall
  '';

  meta = with lib; {
    description = "The C++ Mathematical Expression Toolkit Library";
    homepage = "https://www.partow.net/programming/exprtk/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ anselmschueler ];
  };
}
