{ stdenv, fetchFromGitHub, gtk3, papirus-icon-theme, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-icon-theme";
  version = "15.12.64";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0z1yrp6yg2hb67azrbd9ac743jjh83vxdf2j0mmv2lfpd4fqw8qc";
  };

  nativeBuildInputs = [ gtk3 papirus-icon-theme ];

  postPatch = ''
    patchShebangs .

    # install in $out
    sed -i -e "s|/usr|$out|g" Makefile tools/hicolor.links

    # keep icon-theme.cache
    sed -i -e 's|\(-rm -f .*/icon-theme.cache\)|# \1|g' Makefile
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Icons for the Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-icon-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
