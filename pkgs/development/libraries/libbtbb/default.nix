{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  CoreServices,
}:

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

  # https://github.com/greatscottgadgets/libbtbb/issues/63
  postPatch = ''
    substituteInPlace lib/libbtbb.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    description = "Bluetooth baseband decoding library";
    homepage = "https://github.com/greatscottgadgets/libbtbb";
    license = licenses.gpl2;
    maintainers = with maintainers; [ oxzi ];
  };
}
