{ lib, stdenv, fetchurl, autoreconfHook, libmd }:

stdenv.mkDerivation rec {
  pname = "libbsd";
  version = "0.11.3";

  src = fetchurl {
    url = "https://libbsd.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "18a2bcl9z0zyxhrm1lfv4yhhz0589s6jz0s78apaq78mhj0wz5gz";
  };

  outputs = [ "out" "dev" "man" ];

  # darwin changes configure.ac which means we need to regenerate
  # the configure scripts
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libmd ];

  patches = [ ./darwin.patch ];

  meta = with lib; {
    description = "Common functions found on BSD systems";
    homepage = "https://libbsd.freedesktop.org/";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
