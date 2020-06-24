{ lib, mkFont, fetchurl }:

{
  tai-ahom = mkFont {
    pname = "tai-ahom";
    version = "2015-07-06";

    src = fetchurl {
      url = "https://github.com/enabling-languages/tai-languages/blob/b57a3ea4589af69bb8e87c6c4bb7cd367b52f0b7/ahom/.fonts/ttf/.original/AhomUnicode_FromMartin.ttf?raw=true";
      sha256 = "0zpjsylm29qc3jdv5kv0689pcirai46j7xjp5dppi0fmzxaxqnsk";
      name = "AhomUnicode_FromMartin.ttf";
    };

    noUnpackFonts = true;

    meta = with lib; {
      homepage = "https://github.com/enabling-languages/tai-languages";
      description = "Unicode-compliant Tai Ahom font";
      license = licenses.ofl; # See font metadata
      platforms = platforms.all;
      maintainers = with maintainers; [ mathnerd314 ];
    };
  };

# TODO: package others (Khamti Shan, Tai Aiton, Tai Phake, and/or Assam Tai)

}
