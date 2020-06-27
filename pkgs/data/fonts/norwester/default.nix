{ lib, mkFont, fetchzip }:

mkFont {
  version = "1.2";
  pname = "norwester";

  src = fetchzip {
    url = "http://jamiewilson.io/norwester/assets/norwester.zip";
    sha256 = "1j3zb3g8d4hya6fqdczyyzhpnflmb4cj4gvb37cga4yhpahyfkq2";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "http://jamiewilson.io/norwester";
    description = "A condensed geometric sans serif by Jamie Wilson";
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
