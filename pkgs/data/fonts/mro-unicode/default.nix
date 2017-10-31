{ lib, fetchzip }:

fetchzip {
  name = "mro-unicode-2013-05-25";

  url = "https://github.com/phjamr/MroUnicode/raw/master/MroUnicode-Regular.ttf";

  postFetch = "install -Dm644 $downloadedFile $out/share/fonts/truetype/MroUnicode-Regular.ttf";

  sha256 = "1i71bjd9gdyn8ladfncbfhz6xz1h8xx8yf876j1z8lh719410c8g";

  meta = with lib; {
    homepage = https://github.com/phjamr/MroUnicode;
    description = "Unicode-compliant Mro font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
