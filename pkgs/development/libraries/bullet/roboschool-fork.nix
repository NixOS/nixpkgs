{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGLU,
  libGL,
  libglut,
}:

stdenv.mkDerivation {
  pname = "bullet";
  version = "2019-03-27";

  src = fetchFromGitHub {
    owner = "olegklimov";
    repo = "bullet3";
    # roboschool needs the HEAD of a specific branch of this fork, see
    # https://github.com/openai/roboschool/issues/126#issuecomment-421643980
    # https://github.com/openai/roboschool/pull/62
    # https://github.com/openai/roboschool/issues/124
    rev = "3687507ddc04a15de2c5db1e349ada3f2b34b3d6";
    sha256 = "1wd7vj9136dl7lfb8ll0rc2fdl723y3ls9ipp7657yfl2xrqhvkb";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libGLU
    libGL
    libglut
  ];

  patches = [ ./gwen-narrowing.patch ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_CPU_DEMOS=OFF"
    "-DINSTALL_EXTRA_LIBS=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DBUILD_BULLET2_DEMOS=OFF"
    "-DBUILD_UNIT_TESTS=OFF"
  ];

  meta = with lib; {
    description = "Professional free 3D Game Multiphysics Library";
    longDescription = ''
      Bullet 3D Game Multiphysics Library provides state of the art collision
      detection, soft body and rigid body dynamics.
    '';
    homepage = "http://bulletphysics.org";
    license = licenses.zlib;
    platforms = platforms.unix;
    # /tmp/nix-build-bullet-2019-03-27.drv-0/source/src/Bullet3Common/b3Vector3.h:297:7: error: argument value 10880 is outside the valid range [0, 255] [-Wargument-outside-range]
    #                 y = b3_splat_ps(y, 0x80);
    broken = (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64);
  };
}
