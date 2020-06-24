{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "mno16";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/sevmeyer/${pname}/releases/download/${version}/${pname}-${version}.zip";
    sha256 = "1qq3w39gx9w3wnyfblcm5bm95sa9gxcn0sl8g72486d5n5bkv564";
    stripRoot = false;
  };

  meta = with lib; {
    description = "minimalist monospaced font";
    homepage = "https://sev.dev/fonts/mno16";
    license = licenses.cc0;
  };
}
