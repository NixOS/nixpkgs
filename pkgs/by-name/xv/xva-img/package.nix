{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "xva-img";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "eriklax";
    repo = "xva-img";
    rev = version;
    sha256 = "sha256-QHCKGsHSMT2P64No1IUCjenm1XZMSgEvsJGJOyHFZS8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  meta = with lib; {
    maintainers = with maintainers; [ willibutz ];
    description = "Tool for converting Xen images to raw and back";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "xva-img";
  };
}
