{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "ankacoder";
  version = "1.100";

  src = fetchzip {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/anka-coder-fonts/AnkaCoder.${version}.zip";
    sha256 = "09mkvfz2jb08b5mj4sr4rn460xjsqqjy23md1vbfyz1z4iljv0np";
    stripRoot = false;
  };

  meta = with lib; {
    description = "Anka/Coder fonts";
    homepage = "https://code.google.com/archive/p/anka-coder-fonts";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
