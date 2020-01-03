{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "theme-jade1";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "theme-jade-1";
    rev = "v${version}";
    sha256 = "1m3150iyk8421mkwj4x2pv29wjzqdcnvvnp3bsg11k5kszsm27a8";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Jade-1 $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "Fork of the original Linux Mint theme with dark menus, more intensive green and some other modifications";
    homepage = https://github.com/madmaxms/theme-jade-1;
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
