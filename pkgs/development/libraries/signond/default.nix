{
  stdenv,
  qt5,
  fetchFromGitLab,
  pkgconfig,
  qtbase,
  qttools,
  libproxy,
  libsignon-glib,
  qmake,
  doxygen,
  graphviz
}:

qt5.mkDerivation rec {

  pname = "signond";
  version = "8.60";

  src = fetchFromGitLab {
    repo = "signond";
    owner = "accounts-sso";
    rev = "VERSION_${version}";
    sha256 = "0bpjcpp3qsf44m5bd4zz8p78pgb0mdsxzmky7wl93dzfblkmwnm4";
  };

  nativeBuildInputs = [
    doxygen
    pkgconfig
    qmake
  ];

  buildInputs = [
    qtbase
    qttools
    graphviz
    libproxy
    libsignon-glib
  ];

  preConfigure = ''
    # don't install example plugin
    sed -e "/example/d" -i src/plugins/plugins.pro
    #disable tests
    sed -i -e '/^SUBDIRS/s/tests//' signon.pro
  '';

  meta = with stdenv.lib; {
    description = "A D-Bus service which performs user authentication on behalf of its clients.";
    homepage = "https://gitlab.com/accounts-sso/signond";
    platforms = platforms.linux;
    license = with licenses; [ lgpl21 ];

    maintainers = [ maintainers.konstantsky ];
  };
}
