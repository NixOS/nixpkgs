{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "nahid-fonts";
  version = "0.3.0";

  src = fetchFromGitHub {
    name = "${pname}-${version}";
    owner = "rastikerdar";
    repo = "nahid-font";
    rev = "v${version}";
    sha256 = "0df169sibq14j2mj727sq86c00jm1nz8565v85hkvh4zgz2plb7c";
  };

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/nahid-font";
    description = "A Persian (Farsi) Font - قلم (فونت) فارسی ناهید";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
