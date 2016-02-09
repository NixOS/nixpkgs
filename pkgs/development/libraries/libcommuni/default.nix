{ fetchgit, qt5, stdenv
}:

stdenv.mkDerivation rec {
  name = "libcommuni-${version}";
  version = "2016-01-02";

  src = fetchgit {
    url = "https://github.com/communi/libcommuni.git";
    rev = "779b0c774428669235d44d2db8e762558e2f4b79";
    sha256 = "15sb7vinaaz1v5nclxpnp5p9a0kmfmlgiqibkipnyydizclidpfx";
  };

  buildInputs = [ qt5.qtbase ];

  enableParallelBuild = true;

  configurePhase = ''
    sed -i -e 's|/bin/pwd|pwd|g' configure
    ./configure -config release -prefix $out -qmake ${qt5.qtbase}/bin/qmake
  '';

  meta = with stdenv.lib; {
    description = "A cross-platform IRC framework written with Qt";
    homepage = https://communi.github.io;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ hrdinka ];
  };
}
