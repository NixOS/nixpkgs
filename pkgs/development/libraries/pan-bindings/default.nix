{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
, cmake
, ncurses
, go
, cargo
, rustPlatform
, asio
}:

let
  version = "unstable-2024-01-19";
  src = fetchFromGitHub {
    owner = "amdfxlucas";
    repo = "pan-bindings";
    rev = "83ddafdd96e86dacce29f0d49902664e0a86c650";
    hash = "sha256-H1gP8s9tYEczu4OxrrMt1RJyuykRoCF89pl/ndGV8wQ=";
  };
  goDeps = (buildGoModule {
    name = "pan-bindings-goDeps";
    inherit src version;
    modRoot = "go";
    vendorHash = "sha256-GRqv3Sht4i7JnLnOXAEP6J0D1QeHiua7u8sI5ymYfhQ=";
  }).goModules;
#  cargoDeps = rustPlatform.fetchCargoTarball {
#    inherit src;
#    name = "pan-bindings-cargoDeps";
#    hash = "sha256-NNfVuS7nNzXy5JbaU4LLU7kAkXMwHo62i/Y/qhZ/JXo=";
#  };
in

stdenv.mkDerivation {
  name = "pan-bindings";

  preBuild = "ls -lah ${goDeps}";
  inherit src;

#  inherit cargoDeps;

  cmakeFlags = [
    "-DBUILD_RUST=0"
  ];

  patchPhase = ''
    runHook prePatch
    export HOME=$TMP
    cp -r --reflink=auto ${goDeps} go/vendor
    runHook postPatch
  '';

  buildInputs = [
    ncurses
    asio
  ];

  nativeBuildInputs = [
#    rustPlatform.cargoSetupHook
    cargo
    cmake
    go
  ];

  meta = with lib; {
    description = "SCION PAN Bindings for C, C++, and Python";
    homepage = "https://github.com/lschulz/pan-bindings";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "pan-bindings";
    platforms = platforms.all;
  };
}
