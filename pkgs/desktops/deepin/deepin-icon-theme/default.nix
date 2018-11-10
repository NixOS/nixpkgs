{ stdenv, fetchFromGitHub, gtk3, papirus-icon-theme }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-icon-theme";
  version = "15.12.60";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "01iaxi4x4zic67yz9khjwl516wb3rnajcfqrkwaich8209isk6yf";
  };

  nativeBuildInputs = [ gtk3 papirus-icon-theme ];

  postPatch = ''
    patchShebangs .

    # install in $out
    sed -i -e "s|/usr|$out|g" Makefile tools/hicolor.links

    # keep icon-theme.cache
    sed -i -e 's|\(-rm -f .*/icon-theme.cache\)|# \1|g' Makefile
  '';

  meta = with stdenv.lib; {
    description = "Icons for the Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-icon-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
