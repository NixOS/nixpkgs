{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "chonburi";
  version = "unstable-2021-09-15";

  src = fetchFromGitHub {
    owner = "cadsondemak";
    repo = pname;
    rev = "daf26bf77d82fba50eaa3aa3fad905cb9f6b5e28";
    sha256 = "sha256-oC7ZCfNOyvGtqT9+Ap/CfCHzdWNzeCuac2dJ9fctgB8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/doc/chonburi $out/share/fonts/{opentype,truetype}

    cp $src/OFL.txt $src/BRIEF.md $out/share/doc/chonburi
    cp $src/fonts/*.otf $out/share/fonts/opentype
    cp $src/fonts/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://cadsondemak.github.io/chonburi/";
    description = "Didonic Thai and Latin display typeface";
    longDescription = ''
      The objective of this project is to create a Thai and Latin Display
      typeface. Chonburi is a display typeface with high contrast in a Didone
      style. This single-weight typeface provides advance typographical support
      with features such as discretionary ligature. This font can be extended
      the family to other weights including both narrow and extended version. It
      is also ready to be matched with other non-Latin script.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.toastal ];
  };
}
