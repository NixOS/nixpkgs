{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2017-01-25";

  package-name = "numix-icon-theme";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "271471c7944d592a1d666910de0adce82a393d31";
    sha256 = "1yc9jk1233ybk6cd7q4x3q87rwgq9nkcgkn9fw9si422dkvnwd7h";
  };

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
