{ stdenv, fetchFromGitHub, unzip }:

stdenv.mkDerivation rec {
  version = "4727aa5";

  package-name = "numix-icon-theme-circle";
  
  name = "${package-name}-20151005";

  buildInputs = [ unzip ];
  
  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "0khps3il0wyjizzzv8rxznhywp3nqd1hj1zhdvyqzgql3gffylqc";
  };

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
