{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "mustache";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "kainjow";
    repo = "Mustache";
    rev = "v${version}";
    sha256 = "0r9rbk6v1wpld2ismfsk2lkhbyv3dkf0p03hkjivbj05qkfhvlbb";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp mustache.hpp $out/include

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mustache text templates for modern C++";
    homepage = "https://github.com/kainjow/Mustache";
    license = licenses.boost;
  };
}
