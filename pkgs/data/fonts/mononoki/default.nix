{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "mononoki";
  version = "1.2";

  src = fetchzip {
    url = "https://github.com/madmalik/mononoki/releases/download/${version}/mononoki.zip";
    sha256 = "07ghz2981daxzzqg4kjcya7x46rsvr7p4z4l4gpq8b9l4j2xygfa";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://github.com/madmalik/mononoki";
    description = "A font for programming and code review";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
