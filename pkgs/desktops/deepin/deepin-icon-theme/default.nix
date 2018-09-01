{ stdenv, fetchFromGitHub, gtk3, papirus-icon-theme }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-icon-theme";
  version = "15.12.59";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1qkxhqx6a7pahkjhf6m9lm16lw9v9grk0d4j449h9622zwfjkxlq";
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
