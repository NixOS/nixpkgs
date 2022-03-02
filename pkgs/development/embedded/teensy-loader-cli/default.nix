{ stdenv
, lib
, fetchFromGitHub
, go-md2man
, installShellFiles
, libusb-compat-0_1
, IOKit
, xcbuild
}:

stdenv.mkDerivation rec {
  pname = "teensy-loader-cli";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "PaulStoffregen";
    repo = "teensy_loader_cli";
    rev = "refs/tags/${version}";
    sha256 = "lQ1XtaWPr6nvE8NArD1980QVOH6NggO3FlfsntUjY7s=";
  };

  nativeBuildInputs = [
    go-md2man
    installShellFiles
  ];

  buildInputs =
    if stdenv.isDarwin then [
      IOKit
      xcbuild
    ] else [
      libusb-compat-0_1
    ];

  makeFlags = lib.optional stdenv.isDarwin [ "OS=MACOSX" ];

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
