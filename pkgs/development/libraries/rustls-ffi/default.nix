{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, apacheHttpd, curl }:

rustPlatform.buildRustPackage rec {
  pname = "rustls-ffi";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rustls";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-IDIWN5g1aaE6SDdXSm4WYK6n+BpuypPYQITuDj1WJEc=";
=======
    hash = "sha256-urDC/Tm+ZwEbf0orZzKSET5ljQGVcKPGxscctKOM/FU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  installPhase = ''
    runHook preInstall

    make install DESTDIR=${placeholder "out"}

    runHook postInstall
  '';

  passthru.tests = {
    apacheHttpd = apacheHttpd.override { modTlsSupport = true; };
    curl = curl.override { opensslSupport = false; rustlsSupport = true; };
  };

  meta = with lib; {
    description = "C-to-rustls bindings";
    homepage = "https://github.com/rustls/rustls-ffi/";
    license = with lib.licenses; [ mit asl20 isc ];
    maintainers = [ maintainers.lesuisse ];
  };
}
