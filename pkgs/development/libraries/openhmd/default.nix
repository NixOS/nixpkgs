{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, hidapi
, SDL2
, libGL
, glew
, withExamples ? true
}:

let examplesOnOff = if withExamples then "ON" else "OFF"; in

stdenv.mkDerivation rec {
  pname = "openhmd";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "OpenHMD";
    repo = "OpenHMD";
    rev = version;
    sha256 = "1hkpdl4zgycag5k8njvqpx01apxmm8m8pvhlsxgxpqiqy9a38ccg";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    hidapi
  ] ++ lib.optionals withExamples [
    SDL2
    glew
    libGL
  ];

  cmakeFlags = [
    "-DBUILD_BOTH_STATIC_SHARED_LIBS=ON"
    "-DOPENHMD_EXAMPLE_SIMPLE=${examplesOnOff}"
    "-DOPENHMD_EXAMPLE_SDL=${examplesOnOff}"
    "-DOpenGL_GL_PREFERENCE=GLVND"

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  postInstall = lib.optionalString withExamples ''
    mkdir -p $out/bin
    install -D examples/simple/simple $out/bin/openhmd-example-simple
    install -D examples/opengl/openglexample $out/bin/openhmd-example-opengl
  '';

  meta = with lib; {
    homepage = "http://www.openhmd.net"; # https does not work
    description = "Library API and drivers immersive technology";
    longDescription = ''
      OpenHMD is a very simple FLOSS C library and a set of drivers
      for interfacing with Virtual Reality (VR) Headsets aka
      Head-mounted Displays (HMDs), controllers and trackers like
      Oculus Rift, HTC Vive, Windows Mixed Reality, and etc.
    '';
    license = licenses.boost;
    maintainers = with maintainers; [ oxij ];
    platforms = platforms.unix;
  };
}
