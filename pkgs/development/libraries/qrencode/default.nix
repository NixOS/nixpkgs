{ stdenv, fetchurl, pkgconfig, SDL2, libpng, libiconv }:

stdenv.mkDerivation rec {
  pname = "qrencode";
  version = "4.0.2";

  outputs = [ "bin" "out" "man" "dev" ];

  src = fetchurl {
    url = "https://fukuchi.org/works/qrencode/qrencode-${version}.tar.gz";
    sha256 = "079v3a15ydpr67zdi3xbgvic8n2kxvi0m32dyz8jaik10yffgayv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ SDL2 libpng ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  configureFlags = [
    "--with-tests"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    pushd tests
    ./test_basic.sh
    popd

    runHook postCheck
  '';

  meta = with stdenv.lib; {
    homepage = https://fukuchi.org/works/qrencode/;
    description = "C library for encoding data in a QR Code symbol";

    longDescription = ''
      Libqrencode is a C library for encoding data in a QR Code symbol,
      a kind of 2D symbology that can be scanned by handy terminals
      such as a mobile phone with CCD.
    '';

    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ adolfogc yegortimoshenko ];
    platforms = platforms.all;
  };
}
