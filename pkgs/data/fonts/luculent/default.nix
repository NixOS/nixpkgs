{ lib, mkFont, fetchzip }:

mkFont {
  pname = "luculent";
  version = "2.0.0";

  src = fetchzip {
    url =  "http://www.eastfarthing.com/luculent/luculent.tar.xz";
    sha256 = "1kd6dccribwxfghnp7qxbjjjlcmd0spmxvk5z9c9h36r46vcb46x";
  };

  meta = with lib; {
    description = "luculent font";
    homepage = "http://www.eastfarthing.com/luculent/";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
