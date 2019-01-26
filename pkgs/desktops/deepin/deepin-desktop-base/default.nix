{ stdenv, fetchFromGitHub, deepin-wallpapers, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-desktop-base";
  version = "2018.10.29";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0l2zb7rpag2q36lqsgvirhjgmj7w243nsi1rywkypf2xm7g2v235";
  };

  buildInputs = [ deepin-wallpapers ];

  postPatch = ''
    sed -i Makefile -e "s:/usr:$out:" -e "s:/etc:$out/etc:"
  '';

  postInstall = ''
    # Remove Deepin distro's lsb-release
    rm $out/etc/lsb-release

    # Don't override systemd timeouts
    rm -r $out/etc/systemd

    # Remove apt-specific templates
    rm -r $out/share/python-apt

    # Remove empty backgrounds directory
    rm -r $out/share/backgrounds

    # Make a symlink for deepin-version
    ln -s ../lib/deepin/desktop-version $out/etc/deepin-version
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Base assets and definitions for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-desktop-base;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
