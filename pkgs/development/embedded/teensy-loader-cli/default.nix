{ stdenv
, lib
, fetchFromGitHub
, go-md2man
, installShellFiles
, libusb-compat-0_1
}:

stdenv.mkDerivation rec {
  pname = "teensy-loader-cli";
  version = "2.1+unstable=2021-04-10";

  src = fetchFromGitHub {
    owner = "PaulStoffregen";
    repo = "teensy_loader_cli";
    rev = "9dbbfa3b367b6c37e91e8a42dae3c6edfceccc4d";
    sha256 = "lQ1XtaWPr6nvE8NArD1980QVOH6NggO3FlfsntUjY7s=";
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
    install -Dm444 -t $out/share/doc/${pname} *.md *.txt
    go-md2man -in README.md -out ${pname}.1
    installManPage *.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Firmware uploader for the Teensy microcontroller boards";
    homepage = "https://www.pjrc.com/teensy/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
  };
}
