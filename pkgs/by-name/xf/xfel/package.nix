{
  fetchFromGitHub,
  lib,
  libusb1,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "xfel";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "xboot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fmf+jqCWC7RaLknr/TyRV6VQz4+fp83ynHNk2ACkyfQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  meta = with lib; {
    description = "Tooling for working with the FEL mode on Allwinner SoCs";
    homepage = "https://github.com/xboot/xfel";
    license = licenses.mit;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
