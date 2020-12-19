{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "qrcodegen";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "nayuki";
    repo = "QR-Code-generator";
    rev = "v${version}";
    sha256 = "0iq9sv9na0vg996aqrxrjn9rrbiyy7sc9vslw945p3ky22pw3lql";
  };

  preBuild = "cd c";
  installPhase = ''
    mkdir -p $out/lib $out/include/qrcodegen
    cp libqrcodegen.a $out/lib
    cp qrcodegen.h $out/include/qrcodegen/
  '';

  meta = with stdenv.lib;
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
