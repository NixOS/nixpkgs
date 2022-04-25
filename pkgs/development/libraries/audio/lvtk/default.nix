{ lib, stdenv, fetchFromGitHub, boost, gtkmm2, lv2, pkg-config, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "lvtk";
  version = "unstable-2022-01-19";

  src = fetchFromGitHub {
    owner = "lvtk";
    repo = "lvtk";
    rev = "a73feabe772f9650aa071e6a4df660e549ab7c48";
    hash = "sha256-UukdDortjSAgMKknRtkfaXGUvIQM4xZEQ6hSSRbalWk=";
  };

  nativeBuildInputs = [ pkg-config python3 wafHook ];
  buildInputs = [ lv2 ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A set C++ wrappers around the LV2 C API";
    homepage = "https://lvtk.org/";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
