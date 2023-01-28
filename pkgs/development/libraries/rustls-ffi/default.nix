{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rustls-ffi";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "rustls";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-urDC/Tm+ZwEbf0orZzKSET5ljQGVcKPGxscctKOM/FU=";
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

  meta = with lib; {
    description = "C-to-rustls bindings";
    homepage = "https://github.com/rustls/rustls-ffi/";
    license = with lib.licenses; [ mit asl20 isc ];
    maintainers = [ maintainers.lesuisse ];
  };
}
