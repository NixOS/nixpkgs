{ stdenv, fetchFromGitHub, numix-icon-theme }:

stdenv.mkDerivation rec {
  version = "17-09-13";

  package-name = "numix-icon-theme-circle";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "14ck07j9v0yh8ky191sa3xxi4qh7bbg84i8jijy3kbjcx9s0zl8a";
  };

  buildInputs = [ numix-icon-theme ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix-Circle{,-Light} $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme (circle version)";
    homepage = https://numixproject.org;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jgeerds ];
  };
}
