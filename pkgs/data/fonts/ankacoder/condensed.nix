{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "ankacoder-condensed";
  version = "1.100";

  src = fetchzip {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/anka-coder-fonts/AnkaCoderCondensed.${version}.zip";
    sha256 = "09pflcanxikagycarc1yjbga2dk30hx9bf471f1jzvlvhiby8yil";
    stripRoot = false;
  };

  meta = with lib; {
    description = "Anka/Coder Condensed font";
    homepage = "https://code.google.com/archive/p/anka-coder-fonts";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

