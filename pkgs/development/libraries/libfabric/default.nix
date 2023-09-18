{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, enablePsm2 ? (stdenv.isx86_64 && stdenv.isLinux)
, libpsm2
, enableOpx ? (stdenv.isx86_64 && stdenv.isLinux)
, libuuid
, numactl
}:

stdenv.mkDerivation rec {
  pname = "libfabric";
  version = "1.19.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7VOhdZOPBe1qh8OK8OTNKA5I4A5whl6aOubAzsUDSRw=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = lib.optionals enableOpx [ libuuid numactl ] ++ lib.optionals enablePsm2 [ libpsm2 ];

  configureFlags = [
    (if enablePsm2 then "--enable-psm2=${libpsm2}" else "--disable-psm2")
    (if enableOpx then "--enable-opx" else "--disable-opx")
  ];

  meta = with lib; {
    homepage = "https://ofiwg.github.io/libfabric/";
    description = "Open Fabric Interfaces";
    license = with licenses; [ gpl2 bsd2 ];
    platforms = platforms.all;
    maintainers = [ maintainers.bzizou ];
  };
}
