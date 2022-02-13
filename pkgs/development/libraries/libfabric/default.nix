{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, libpsm2
, enablePsm2 ? (stdenv.isx86_64 && stdenv.isLinux) }:

stdenv.mkDerivation rec {
  pname = "libfabric";
  version = "1.14.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MmvJV3Pne+bJtC91rdpNMZovoqMgm3gHFJwGH3tchgI=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = lib.optional enablePsm2 libpsm2;

  configureFlags = [ (if enablePsm2 then "--enable-psm2=${libpsm2}" else "--disable-psm2") ];

  meta = with lib; {
    homepage = "https://ofiwg.github.io/libfabric/";
    description = "Open Fabric Interfaces";
    license = with licenses; [ gpl2 bsd2 ];
    platforms = platforms.all;
    maintainers = [ maintainers.bzizou ];
  };
}
