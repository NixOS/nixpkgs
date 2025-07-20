{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ncurses,
  SDL2,
  libGL,
  libX11,
}:

stdenv.mkDerivation {
  pname = "tangerine";
  version = "0-unstable-2024-04-05";

  src = fetchFromGitHub {
    owner = "Aeva";
    repo = "tangerine";
    rev = "a628e95d181d396246214df5194ac6b18698d811";
    hash = "sha256-vn4/eH5o0UhTNfN2UB4r0eKNn90PbH3UPfarHsnQPIk=";
  };

  patches = [
    (fetchpatch {
      name = "no-install-during-build.patch";
      url = "https://github.com/Aeva/tangerine/pull/12/commits/2d7d1ae1e21e8fe52df2c4a33e947b2ff6b07812.patch";
      hash = "sha256-zLAx5FOvtUsUZM/nUCFW8Z1Xe3+oV95Nv1s3GaNcV/c=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    ncurses
    SDL2
    libGL
    libX11
  ];

  meta = with lib; {
    description = "System for creating 3D models procedurally from a set of Signed Distance Function (SDF) primitive shapes and combining operators";
    homepage = "https://github.com/Aeva/tangerine";
    license = licenses.asl20;
    maintainers = [ maintainers.viraptor ];
    broken = stdenv.hostPlatform.isDarwin; # third_party/naive-surface-nets doesn't find std::execution
  };
}
