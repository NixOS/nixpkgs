{ stdenv, fetchFromGitHub, cmake, lxqt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-themes";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0f7bipkxkl741lpb2cziw9wlqy05514nqqrppsz5g4y8bmzw910n";
  };

  nativeBuildInputs = [
    cmake
    lxqt.lxqt-build-tools
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_GRAPHICS_DIR}" "DESTINATION \"share/lxqt/graphics"
    substituteInPlace themes/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_SHARE_DIR}" "DESTINATION \"share/lxqt"
  '';

  meta = with stdenv.lib; {
    description = "Themes, graphics and icons for LXQt";
    homepage = https://github.com/lxde/lxqt-themes;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
