{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "recursive";
  version = "1.052";

  src = fetchzip {
    url = "https://github.com/arrowtype/recursive/releases/download/${version}/Recursive-Beta_${version}.zip";
    sha256 = "1sgywyxymys0si3wazmq2mvfcbcwq9m3fkyp29c0vcml0hhxjrh1";
  };

  meta = with lib; {
    homepage = "https://recursive.design/";
    description = "A variable font family for code & UI";
    license = licenses.ofl;
    maintainers = [ maintainers.eadwu ];
    platforms = platforms.all;
  };
}
