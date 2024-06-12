{ lib, stdenv, fetchurl
, meson, ninja
, pkg-config, libGL, ApplicationServices
, testers
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glu";
  version = "9.0.3";

  src = let
    inherit (finalAttrs) pname version;
  in fetchurl {
    url = "https://mesa.freedesktop.org/archive/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-vUP+EvN0sRkusV/iDkX/RWubwmq1fw7ukZ+Wyg+KMw8=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  propagatedBuildInputs = [ libGL ]
    ++ lib.optional stdenv.isDarwin ApplicationServices;

  outputs = [ "out" "dev" ];

  mesonFlags = lib.optionals stdenv.isDarwin [
    "-Dgl_provider=gl" # glvnd is default
  ];

  enableParallelBuilding = true;

  passthru = {
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
    updateScript = gitUpdater {
      # No nicer place to find latest release.
      url = "https://gitlab.freedesktop.org/mesa/glu";
    rev-prefix = "glu-";
    };
  };

  meta = {
    description = "OpenGL utility library";
    homepage = "https://cgit.freedesktop.org/mesa/glu/";
    license = lib.licenses.sgi-b-20;
    pkgConfigModules = [ "glu" ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isAndroid;
  };
})
