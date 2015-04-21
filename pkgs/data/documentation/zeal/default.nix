{ stdenv, fetchFromGitHub, pkgconfig, qt5, libarchive }:

stdenv.mkDerivation rec {
  version = "20141123";
  name = "zeal-${version}";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "76405f8387d6a82697faab9630c78f31417d8450";
    sha256 = "1057py3j2flzxyiks031s0mwm9h82v033iqn5cq8sycmrb3ihj2s";
  };

  buildInputs = [ pkgconfig qt5 libarchive ];

  patchPhase = ''
    substituteInPlace src/main.cpp \
      --replace /usr/share/pixmaps/zeal $out/share/pixmaps/zeal
  '';

  buildPhase = ''
    qmake PREFIX=$out
    make
  '';

  installPhase = ''
    make INSTALL_ROOT=$out install
  '';

  preFixup = ''
    mv $out/usr/bin $out/bin
    mv $out/usr/share $out/share
    rmdir $out/usr
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Zeal is a simple offline API documentation browser";
    longDescription = ''
      Zeal is a simple offline API documentation browser inspired by Dash (OS X
      app), available for Linux and Windows.
    '';
    homepage = "http://zealdocs.org/";
    license = with stdenv.lib.licenses; [ gpl3 ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ skeidel ];
  };
}

