{ stdenv, fetchFromGitHub, deepin-wallpapers }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-desktop-base";
  version = "2018.7.23";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1n1bjkvhgq138jcg3zkwg55r41056x91mh191mirlpvpic574ydc";
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

  meta = with stdenv.lib; {
    description = "Base assets and definitions for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-desktop-base;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
