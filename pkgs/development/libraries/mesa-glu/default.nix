{ lib, stdenv, fetchurl, pkg-config, libGL, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "glu";
  version = "9.0.2";

  src = fetchurl {
    url = "https://mesa.freedesktop.org/archive/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-bnKA/1hcah2d/N8vykiSUWNLM3e/wzwp5AAkZqONAtQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ libGL ]
    ++ lib.optional stdenv.isDarwin ApplicationServices;

  outputs = [ "out" "dev" ];

  meta = {
    description = "OpenGL utility library";
    homepage = "https://cgit.freedesktop.org/mesa/glu/";
    license = lib.licenses.sgi-b-20;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isAndroid;
  };
}
