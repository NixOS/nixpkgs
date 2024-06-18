{ stdenv
, lib
, fetchFromGitHub
, go-md2man
, installShellFiles
, libusb-compat-0_1
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "teensy-loader-cli";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "PaulStoffregen";
    repo = "teensy_loader_cli";
    rev = finalAttrs.version;
    sha256 = "sha256-NYqCNWO/nHEuNc9eOzsUqJEHJtZ3XaNz1VYNbeuqEk8=";
  };

  nativeBuildInputs = [
    go-md2man
    installShellFiles
  ];

  buildInputs = [
    libusb-compat-0_1
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 teensy_loader_cli $out/bin/teensy-loader-cli
    install -Dm444 -t $out/share/doc/teensy-loader-cli *.md *.txt
    go-md2man -in README.md -out teensy-loader-cli.1
    installManPage *.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Firmware uploader for the Teensy microcontroller boards";
    mainProgram = "teensy-loader-cli";
    homepage = "https://www.pjrc.com/teensy/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
  };
})
