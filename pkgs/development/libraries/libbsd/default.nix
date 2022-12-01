{ lib, stdenv, fetchurl, autoreconfHook, libmd }:

stdenv.mkDerivation rec {
  pname = "libbsd";
  version = "0.11.6";

  src = fetchurl {
    url = "https://libbsd.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-GbOPMXLq9pPm4caHFGNhkMfkiFHkUiTXILO1vASZtd8=";
  };

  outputs = [ "out" "dev" "man" ];

  # darwin changes configure.ac which means we need to regenerate
  # the configure scripts
  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ libmd ];

  patches = [ ./darwin.patch ];

  meta = with lib; {
    description = "Common functions found on BSD systems";
    homepage = "https://libbsd.freedesktop.org/";
    license = with licenses; [ beerware bsd2 bsd3 bsdOriginal isc mit ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
