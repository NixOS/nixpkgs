{ stdenv, fetchFromGitHub, gtk3, xcursorgen, papirus-icon-theme, deepin, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "deepin-icon-theme";
  version = "15.12.71";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "12rzzjp906np95ckbxrd4mb345lm198wz69kxy48f8q1zg78q8iw";
  };

  nativeBuildInputs = [ gtk3 xcursorgen ];

  buildInputs = [ papirus-icon-theme ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs tools/hicolor.links
    patchShebangs tools/display_unused_links.sh
    patchShebangs cursors-src/cursors/bitmaps/make.sh
    patchShebangs cursors-src/render-cursors.sh

    # keep icon-theme.cache
    sed -i -e 's|\(-rm -f .*/icon-theme.cache\)|# \1|g' Makefile
  '';

  buildTargets = "all hicolor-links";
  installTargets = [ "install-icons" "install-cursors" ];
  installFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    cp -a ./Sea ./usr/share/icons/hicolor "$out"/share/icons/
  '';

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Icons for the Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-icon-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
