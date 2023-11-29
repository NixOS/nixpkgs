{ lib, stdenv, fetchurl, cmake, qtbase, extra-cmake-modules }:

stdenv.mkDerivation rec {
  pname = "libqaccessibilityclient";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://kde/stable/libqaccessibilityclient/libqaccessibilityclient-${version}.tar.xz";
    sha256 = "sha256-cEdyVDo7AFuUBhpT6vn51klE5oGLBMWcD7ClA8gaxKA=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ qtbase ];

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Accessibilty tools helper library, used e.g. by screen readers";
    homepage = "https://github.com/KDE/libqaccessibilityclient";
    maintainers = with maintainers; [ artturin ];
    license = with licenses; [ lgpl3Only /* or */ lgpl21Only ];
    platforms = platforms.linux;
  };
}
