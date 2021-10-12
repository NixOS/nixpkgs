{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "qrcodegen";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "nayuki";
    repo = "QR-Code-generator";
    rev = "v${version}";
    sha256 = "sha256-WH6O3YE/+NNznzl52TXZYL+6O25GmKSnaFqDDhRl4As=";
  };

  preBuild = "cd c";
  installPhase = ''
    mkdir -p $out/lib $out/include/qrcodegen
    cp libqrcodegen.a $out/lib
    cp qrcodegen.h $out/include/qrcodegen/
  '';

  meta = with lib;
    {
      description = "qrcode generator library in multiple languages";

      longDescription = ''
        This project aims to be the best, clearest library for generating QR Codes. My primary goals are flexible options and absolute correctness. Secondary goals are compact implementation size and good documentation comments.
      '';

      homepage = "https://github.com/nayuki/QR-Code-generator";

      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ mcbeth ];
    };
}
