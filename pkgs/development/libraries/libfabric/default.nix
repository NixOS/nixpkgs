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
<<<<<<< HEAD
  version = "1.18.1";
=======
  version = "1.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-3iQsFfpXSyMFkBeByGJmKSTUXuLsWA0l8t1cCDkNRos=";
=======
    sha256 = "sha256-30ADIUbpzwyxMJtPyLDwXYGJF4c1ZiSJH2mBBtgfE18=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
