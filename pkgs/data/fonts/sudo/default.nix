{ lib, mkFont, fetchzip }:

mkFont rec {
  version = "0.42";
  pname = "sudo-font";

  src = fetchzip {
    url = "https://github.com/jenskutilek/sudo-font/releases/download/v${version}/sudo.zip";
    sha256 = "1dav0mqkdk18wcgmk0nhx53v92fdzfdfqq61sx532rihrvgxcfh6";
  };

  meta = with lib; {
    description = "Font for programmers and command line users";
    homepage = "https://www.kutilek.de/sudo-font/";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

