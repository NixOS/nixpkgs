{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2016-05-18";

  package-name = "numix-icon-theme";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "d571e845b9db0e5cc5a50e6d4423d25fc0d613bd";
    sha256 = "0d9ajh12n1ms7wbgaa3nsdhlwsjwj4flm67cxzsb3dwhpql75z0c";
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
