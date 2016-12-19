{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2016-11-13";

  package-name = "numix-icon-theme";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "45878a1195abd997341c91d51381625644f9a356";
    sha256 = "0in7vx8mdwbfkgylh9p95kcsnn7dnv2vpmv788n0bbgldxmrldga";
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
