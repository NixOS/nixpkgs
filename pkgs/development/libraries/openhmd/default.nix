{ lib, stdenv, fetchFromGitHub, pkgconfig, cmake, hidapi
, withExamples ? true, SDL2 ? null, libGL ? null, glew ? null
}:

with lib;

let onoff = if withExamples then "ON" else "OFF"; in

stdenv.mkDerivation {
  pname = "openhmd";
  version = "0.3.0-rc1-20181218";

  src = fetchFromGitHub {
    owner = "OpenHMD";
    repo = "OpenHMD";
    rev = "80d51bea575a5bf71bb3a0b9683b80ac3146596a";
    sha256 = "09011vnlsn238r5vbb1ab57x888ljaa34xibrnfbm5bl9417ii4z";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [
    hidapi
  ] ++ optionals withExamples [
    SDL2 libGL glew
  ];

  cmakeFlags = [
    "-DBUILD_BOTH_STATIC_SHARED_LIBS=ON"
    "-DOPENHMD_EXAMPLE_SIMPLE=${onoff}"
    "-DOPENHMD_EXAMPLE_SDL=${onoff}"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  postInstall = optionalString withExamples ''
    mkdir -p $out/bin
    install -D examples/simple/simple $out/bin/openhmd-example-simple
    install -D examples/opengl/openglexample $out/bin/openhmd-example-opengl
  '';

  meta = {
    homepage = "http://www.openhmd.net";
    description = "Library API and drivers immersive technology";
    longDescription = ''
      OpenHMD is a very simple FLOSS C library and a set of drivers
      for interfacing with Virtual Reality (VR) Headsets aka
      Head-mounted Displays (HMDs), controllers and trackers like
      Oculus Rift, HTC Vive, Windows Mixed Reality, and etc.
    '';
    license = licenses.boost;
    maintainers = [ maintainers.oxij ];
    platforms = platforms.unix;
  };
}
