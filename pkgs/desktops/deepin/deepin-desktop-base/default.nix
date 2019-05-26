{ stdenv, fetchFromGitHub, deepin-wallpapers, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-desktop-base";
  version = "2019.04.24";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0mdfjkyjrccxlsg05mf80qcw8v5srlp80rvjkpnnbhfscq1fnpgn";
  };

  nativeBuildInputs = [ deepin.setupHook ];

  buildInputs = [ deepin-wallpapers ];

  # TODO: Fedora recommended dependencies:
  #   deepin-wallpapers
  #   plymouth-theme-deepin

  postPatch = ''
    searchHardCodedPaths

    fixPath $out /etc Makefile
    fixPath $out /usr Makefile

    # Remove Deepin distro's lsb-release
    # Don't override systemd timeouts
    # Remove apt-specific templates
    echo ----------------------------------------------------------------
    echo grep --color=always -E 'lsb-release|systemd|python-apt|backgrounds' Makefile
    grep --color=always -E 'lsb-release|systemd|python-apt|backgrounds' Makefile
    echo ----------------------------------------------------------------
    sed -i -E '/lsb-release|systemd|python-apt|backgrounds/d' Makefile
  '';

  postInstall = ''
    # Make a symlink for deepin-version
    ln -s ../lib/deepin/desktop-version $out/etc/deepin-version
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Base assets and definitions for Deepin Desktop Environment";
    # TODO: revise
    longDescription = ''
      This package provides some components for Deepin desktop environment.
      - deepin logo
      - deepin desktop version
      - login screen background image
      - language information
    '';
    homepage = https://github.com/linuxdeepin/deepin-desktop-base;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
