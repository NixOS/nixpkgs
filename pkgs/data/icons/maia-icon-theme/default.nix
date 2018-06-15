{ stdenv, fetchFromGitHub, cmake, extra-cmake-modules, gtk3, kdeFrameworks }:

stdenv.mkDerivation rec {
  name = "maia-icon-theme-${version}";
  version = "2016-09-16";

  src = fetchFromGitHub {
    owner = "manjaro";
    repo = "artwork-maia";
    rev = "f6718cd9c383adb77af54b694c47efa4d581f5b5";
    sha256 = "0f9l3k9abgg8islzddrxgbxaw6vbai5bvz5qi1v2fzir7ykx7bgj";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gtk3
    kdeFrameworks.plasma-framework
    kdeFrameworks.kwindowsystem
  ];

  meta = with stdenv.lib; {
    description = "Icons based on Breeze and Super Flat Remix";
    homepage = https://github.com/manjaro/artwork-maia;
    license = licenses.free; # https://github.com/manjaro/artwork-maia/issues/27
    maintainers = with maintainers; [ mounium ];
    platforms = platforms.all;
  };
}
