{ lib, mkFont, fetchurl, p7zip }:

mkFont rec {
  pname = "sarasa-gothic";
  version = "0.12.6";

  src = fetchurl {
    url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttc-${version}.7z";
    sha256 = "1g6k9d5lajchbhsh3g12fk5cgilyy6yw09fals9vc1f9wsqvac86";
  };

  nativeBuildInputs = [ p7zip ];
  sourceRoot = ".";

  meta = with lib; {
    description = "SARASA GOTHIC is a Chinese & Japanese programming font based on Iosevka and Source Han Sans";
    homepage = "https://github.com/be5invis/Sarasa-Gothic";
    license = licenses.ofl;
    maintainers = [ maintainers.ChengCat ];
    platforms = platforms.all;
  };
}
