{ stdenv, fetchFromGitHub, hicolor_icon_theme }:

stdenv.mkDerivation rec {
  version = "17-12-25";

  package-name = "numix-icon-theme";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "0q3hpq2jc9iwnzzqpb12g1qzjsw4ckhdqkfqf6nirl87r5drkv6j";
  };

  buildInputs = [ hicolor_icon_theme ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix{,-Light} $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme";
    homepage = https://numixproject.org;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo jgeerds ];
  };
}
