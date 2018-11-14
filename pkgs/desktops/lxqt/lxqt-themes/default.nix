{ stdenv, fetchFromGitHub, cmake, lxqt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-themes";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "026hbblxdbq48n9691b1z1xiak99khsk3wf09vn4iaj5zi7dwhw5";
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
    homepage = https://github.com/lxqt/lxqt-themes;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
