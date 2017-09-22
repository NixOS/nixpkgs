{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2017-09-17";

  package-name = "numix-icon-theme";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "d0e7da93520e521bf7df7cffa3620c10a8400a7f";
    sha256 = "1my43kv9yz9vdn51zhd13c8zavba17cqrmxkmhpx0c8xldjqfp3i";
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
