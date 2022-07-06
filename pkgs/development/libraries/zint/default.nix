{ cmake, qt6, withGui ? true, lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "zint";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "zint";
    repo = "zint";
    rev = version;
    sha256 = "sha256-DtfyXBBEDcltGUAutHl/ksRTTYmS7Ll9kjfgD7NmBbA=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals withGui [ qt6.wrapQtAppsHook ];
  buildInputs = lib.optionals withGui (with qt6; [ qtbase qttools ]);

  meta = with lib; {
    description = "A barcode encoding library plus CLI and GUI frontends";
    longDescription = ''
      A barcode encoding library supporting over 50 symbologies including Code 128,
      Data Matrix, USPS OneCode, EAN-128, UPC/EAN, ITF, QR Code, Code 16k, PDF417,
      MicroPDF417, LOGMARS, Maxicode, GS1 DataBar, Aztec, Composite Symbols and more
    '';
    homepage = "https://zint.github.io";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ eigengrau ];
  };
}
