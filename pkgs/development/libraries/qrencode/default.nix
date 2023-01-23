{ lib, stdenv, fetchurl, pkg-config, SDL2, libpng, libiconv, libobjc }:

stdenv.mkDerivation rec {
  pname = "qrencode";
  version = "4.1.1";

  outputs = [ "bin" "out" "man" "dev" ];

  src = fetchurl {
    url = "https://fukuchi.org/works/qrencode/qrencode-${version}.tar.gz";
    sha256 = "sha256-2kSO1PUqumvLDNSMrA3VG4aSvMxM0SdDFAL8pvgXHo4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpng ]
    ++ lib.optionals stdenv.isDarwin [ libiconv libobjc ];

  configureFlags = [
    "--with-tests"
  ];

  nativeCheckInputs = [ SDL2 ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    pushd tests
    ./test_basic.sh
    popd

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://fukuchi.org/works/qrencode/";
    description = "C library for encoding data in a QR Code symbol";
    longDescription = ''
      Libqrencode is a C library for encoding data in a QR Code symbol,
      a kind of 2D symbology that can be scanned by handy terminals
      such as a mobile phone with CCD.
    '';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ adolfogc yana ];
    platforms = platforms.all;
  };
}
