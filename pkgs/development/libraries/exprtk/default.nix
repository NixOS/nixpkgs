{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "exprtk";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "ArashPartow";
    repo = pname;
    rev = version;
    hash = "sha256-ZV5nS6wEbKfzXhfXEtVlkwaEtxpTOYQaGlaxKx3FIvE=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 exprtk.hpp "$out/include/exprtk.hpp"
    runHook postInstall
  '';

  meta = with lib; {
    description = "C++ Mathematical Expression Toolkit Library";
    homepage = "https://www.partow.net/programming/exprtk/index.html";
    license = licenses.mit;
    maintainers = [ ];
  };
}
