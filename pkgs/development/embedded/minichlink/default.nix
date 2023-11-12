{ stdenv, lib, fetchFromGitHub, libusb1 }:

stdenv.mkDerivation rec {
  pname = "minichlink";
  version = "bbe0e8333eca4d3f74b774491be8bf5716c9f27b";

  src = fetchFromGitHub {
    owner = "cnlohr";
    repo = "ch32v003fun";
    rev = version;
    sha256 = "sha256-hHU+TrBHGtAIt7plD4cKdYDtS6fjPpnXItD6IQdAPgM=";
  };

  buildInputs = [
    libusb1.dev
  ];

  makeFlags = [
    "-C minichlink"
  ];

  installPhase = ''
    install -Dm755 -t $out/bin minichlink/minichlink
  '' + lib.optionalString stdenv.isLinux ''
    install -Dm644 -t $out/etc/udev/rules.d minichlink/99-minichlink.rules
  '';

  meta = with lib; {
    description = "A free, open mechanism to use the CH-LinkE $4 programming dongle for the CH32V003";
    homepage = "https://github.com/cnlohr/ch32v003fun/tree/master/minichlink";
    license = licenses.mit;
    maintainers = with maintainers; [ marble ];
    platforms = platforms.unix;
  };
}
