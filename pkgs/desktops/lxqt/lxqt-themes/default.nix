{ lib, mkDerivation, fetchFromGitHub, cmake, lxqt-build-tools }:

mkDerivation rec {
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

  meta = with lib; {
    description = "Themes, graphics and icons for LXQt";
    homepage = https://github.com/lxqt/lxqt-themes;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
