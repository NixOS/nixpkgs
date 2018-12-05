{ stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  pname = "open-sans";
  version = "1.11";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "fonts-team";
    repo = "fonts-open-sans";
    rev = "debian%2F1.11-1"; # URL-encoded form of "debian/1.11-1" tag
    sha256 = "077hkvpmk3ghbqyb901w43b2m2a27lh8ddasyx1x7pdwyr2bjjl2";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    description = "Open Sans fonts";
    longDescription = ''
      Open Sans is a humanist sans serif typeface designed by Steve Matteson,
      Type Director of Ascender Corp.
    '';
    homepage = https://www.opensans.com;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.worldofpeace ];
  };
}
