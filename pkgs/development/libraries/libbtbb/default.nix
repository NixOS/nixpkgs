{ stdenv, lib, fetchFromGitHub, cmake, CoreServices }:

stdenv.mkDerivation rec {
  pname = "libbtbb";
  version = "2020-12-R1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = pname;
    rev = version;
    sha256 = "1byv8174xam7siakr1p0523x97wkh0fmwmq341sd3g70qr2g767d";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Bluetooth baseband decoding library";
    homepage = "https://github.com/greatscottgadgets/libbtbb";
    license = licenses.gpl2;
    maintainers = with maintainers; [ oxzi ];
  };
}
