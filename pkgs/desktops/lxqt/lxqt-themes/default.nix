{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools }:

stdenv.mkDerivation rec {
  pname = "lxqt-themes";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "09dkcgnf3lmfly8v90p6wjlj5rin83pbailvvpx2jr8a48a8zb9f";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_GRAPHICS_DIR}" "DESTINATION \"share/lxqt/graphics"
    substituteInPlace themes/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_SHARE_DIR}" "DESTINATION \"share/lxqt"
  '';

  meta = with stdenv.lib; {
    description = "Themes, graphics and icons for LXQt";
    homepage = https://github.com/lxqt/lxqt-themes;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
