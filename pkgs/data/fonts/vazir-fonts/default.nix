{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "vazir-fonts";
  version = "22.1.0";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "vazir-font";
    rev = "v${version}";

    sha256 = "0k34xcf3r7pfpsvyk0rzcgiz0x34ynaa7i1rmwp7c6v7lkfri14l";
  };

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/vazir-font";
    description = "A Persian (Farsi) Font - قلم (فونت) فارسی وزیر";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
