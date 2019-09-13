{ stdenv, fetchFromGitHub, deepin-wallpapers, deepin }:

stdenv.mkDerivation rec {
  pname = "deepin-desktop-base";
  version = "2019.06.19";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1r158x4z4qalv4q1ni3aln05krdzblvr7y6wyciwl7cr5ag1i1jy";
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

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

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
