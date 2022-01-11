{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, libusb1, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "ecpdap";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "adamgreig";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fdvpGmEy54i48H6YJ4E1LIuogimNEL8PJS5ScoW/6DM=";
  };

  cargoSha256 = "sha256-2YARNoHVDBwGr8FE/oRlNZMX/vCPIre7OnZbr04eF/M=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ]
    ++ lib.optional stdenv.isDarwin AppKit;

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp drivers/*.rules $out/etc/udev/rules.d
  '';

  meta = with lib; {
    description = "A tool to program ECP5 FPGAs";
    longDescription = ''
      ECPDAP allows you to program ECP5 FPGAs and attached SPI flash
      using CMSIS-DAP probes in JTAG mode.
    '';
    homepage = "https://github.com/adamgreig/ecpdap";
    license = licenses.asl20;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}

