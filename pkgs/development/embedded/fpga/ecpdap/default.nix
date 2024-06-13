{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, libusb1, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "ecpdap";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "adamgreig";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KXfEQnbhUUKsCDKhPBjwjF9eJMuiCx5o7gOSzyWv36s=";
  };

  cargoSha256 = "sha256-BEfsNSzrdV/tnzWk4oOwchOupW6PzZ8TEx7zUzwLBV8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ]
    ++ lib.optional stdenv.isDarwin AppKit;

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp drivers/*.rules $out/etc/udev/rules.d
  '';

  meta = with lib; {
    description = "Tool to program ECP5 FPGAs";
    mainProgram = "ecpdap";
    longDescription = ''
      ECPDAP allows you to program ECP5 FPGAs and attached SPI flash
      using CMSIS-DAP probes in JTAG mode.
    '';
    homepage = "https://github.com/adamgreig/ecpdap";
    license = licenses.asl20;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}

