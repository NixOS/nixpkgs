{ lib, fetchFromGitHub }:

fetchFromGitHub rec {
  pname = "montserrat";
  version = "7.222";

  owner = "JulietaUla";
  repo = pname;
  rev = "v${version}";
  sha256 = "sha256-MeNnc1e5X5f0JyaLY6fX22rytHkvL++eM2ygsdlGMv0=";

  postFetch = ''
    mkdir -p $out/share/fonts/{otf,ttf,woff,woff2}

    mv $out/fonts/otf/*.otf $out/share/fonts/otf
    mv $out/fonts/ttf/*.ttf $out/share/fonts/ttf
    mv $out/fonts/webfonts/*.woff $out/share/fonts/woff
    mv $out/fonts/webfonts/*.woff2 $out/share/fonts/woff2

    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  meta = with lib; {
    description = "A geometric sans serif font with extended latin support (Regular, Alternates, Subrayada)";
    homepage = "https://www.fontspace.com/julieta-ulanovsky/montserrat";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ scolobb jk ];
  };
}
