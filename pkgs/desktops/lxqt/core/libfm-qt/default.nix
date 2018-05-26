{
  stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools,
  pcre, libexif, xorg, libfm, menu-cache,
  qtx11extras, qttools
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "libfm-qt";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0932yl098pc5rwgy9irrc3ys47jx64m3wm702dvs8yy15alv6x4i";
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
    homepage = https://github.com/lxde/libfm-qt;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
