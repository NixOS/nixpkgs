{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "qrcodegen";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "nayuki";
    repo = "QR-Code-generator";
    rev = "v${version}";
    sha256 = "sha256-WH6O3YE/+NNznzl52TXZYL+6O25GmKSnaFqDDhRl4As=";
  };

  preBuild = ''
    cd c/
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/include/qrcodegen
    cp libqrcodegen.a $out/lib
    cp qrcodegen.h $out/include/qrcodegen/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.nayuki.io/page/qr-code-generator-library";
    description = "High-quality QR Code generator library in many languages";
    license = licenses.mit;
    maintainers = with maintainers; [ mcbeth AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
# TODO: build the other languages
# TODO: multiple outputs
