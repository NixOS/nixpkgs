{ lib, stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "theme-jade1";
  version = "1.13";

  src = fetchurl {
    url = "https://github.com/madmaxms/theme-jade-1/releases/download/v${version}/jade-1-theme.tar.xz";
    sha256 = "04a9c56w4hm8lwa8hzy5lwj4yli19gzy5wp5iinsm61qas9xgy69";
  };

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Jade* $out/share/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "Based on Linux Mint theme with dark menus and more intensive green";
    homepage = "https://github.com/madmaxms/theme-jade-1";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
