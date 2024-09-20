{ lib, stdenv, fetchFromGitHub, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libevdevplus";
  version = "unstable-2021-04-02";

  # adds missing cmake install directives
  # https://github.com/YukiWorkshop/libevdevPlus/pull/10
  patches = [ ./0001-Add-cmake-install-directives.patch];

  src  = fetchFromGitHub {
    owner  = "YukiWorkshop";
    repo   = "libevdevPlus";
    rev    = "b4d4b3143056424a3da9f0516ca02a47209ef757";
    sha256 = "09y65s16gch0w7fy1s9yjk9gz3bjzxix36h5wmwww6lkj2i1z3rj";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Easy-to-use event device library in C++";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    platforms = with platforms; linux;
  };
}
