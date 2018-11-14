{
  stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools,
  pcre, libexif, xorg, libfm, menu-cache,
  qtx11extras, qttools
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "libfm-qt";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1g8j1lw74qvagqhqsx45b290fjwh3jfl3i0366m0w4la03v0rw5j";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    pcre
    libexif
    xorg.libpthreadstubs
    xorg.libxcb
    xorg.libXdmcp
    qtx11extras
    qttools
    libfm
    menu-cache
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    homepage = https://github.com/lxqt/libfm-qt;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
