{ lib, fetchzip, mkFont }:

mkFont rec {
  pname = "aileron";
  version = "0.102";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${pname}_${lib.replaceStrings ["."] [""] version}.zip";
    sha256 = "1hawb176dd90nq95q5blpmpv93v7qyl9fwldiqfpvbjr0a1krphy";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://dotcolon.net/font/${pname}/";
    description = "A helvetica font in nine weights";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.cc0;
  };
}
