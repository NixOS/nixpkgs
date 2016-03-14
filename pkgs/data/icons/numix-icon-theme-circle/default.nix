{ stdenv, fetchFromGitHub, unzip }:

stdenv.mkDerivation rec {
  version = "e7008b488edfe37379ba9c4b8d5245dfd6125fc3";

  package-name = "numix-icon-theme-circle";
  
  name = "${package-name}-20160121-${version}";

  buildInputs = [ unzip ];
  
  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "0pfcz50b9g7zzskws94m6wvd8zm3sjvhpbzq9vjqi1q02nzflap6";
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
