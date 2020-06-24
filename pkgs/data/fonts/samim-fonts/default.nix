{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "samim-fonts";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "samim-font";
    rev = "v${version}";
    sha256 = "1mp0pgbn9r098ilajwzag7c21shwb13mq61ly9av0mfbpnhkkjqk";
  };

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/samim-font";
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی صمیم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ linarcx ];
  };
}
