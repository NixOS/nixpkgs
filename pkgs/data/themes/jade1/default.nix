{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "theme-jade1";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "theme-jade-1";
    rev = "v${version}";
    sha256 = "1lnajrsikw6dljf6dvgmj8aqwywmgdp34h3xsc0xiyq07arhp606";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Jade* $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "Fork of the original Linux Mint theme with dark menus, more intensive green and some other modifications";
    homepage = "https://github.com/madmaxms/theme-jade-1";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
