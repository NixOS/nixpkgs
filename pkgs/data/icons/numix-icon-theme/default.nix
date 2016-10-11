{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2016-10-05";

  package-name = "numix-icon-theme";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "e03eb71454c176a98733eafa268ff79995f8159d";
    sha256 = "1f8prwq9zvzfk0ncwzbrwkpjggc8nadny81dqv1cr0014jc85bxi";
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
