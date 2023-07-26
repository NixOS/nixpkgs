{ lib, stdenv, fetchurl, pkg-config, libGL, ApplicationServices
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glu";
  version = "9.0.2";

  src = let
    inherit (finalAttrs) pname version;
  in fetchurl {
    url = "https://mesa.freedesktop.org/archive/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-bnKA/1hcah2d/N8vykiSUWNLM3e/wzwp5AAkZqONAtQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ libGL ]
    ++ lib.optional stdenv.isDarwin ApplicationServices;

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "OpenGL utility library";
    homepage = "https://cgit.freedesktop.org/mesa/glu/";
    license = lib.licenses.sgi-b-20;
    pkgConfigModules = [ "glu" ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isAndroid;
  };
})
