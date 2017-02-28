{
  stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools,
  xorg, libfm, menu-cache,
  qtx11extras, qttools
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "libfm-qt";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0k2g6bkz7bvawqkjzykbxi18wqsnhbxklqy6aqqkclpzcw45vk5v";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qtx11extras
    qttools
    libfm
    menu-cache
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    homepage = https://github.com/lxde/libfm-qt;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
