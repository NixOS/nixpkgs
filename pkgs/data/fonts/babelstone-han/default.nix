{ lib, mkFont, fetchzip }:

mkFont {
  pname = "babelstone-han";
  version = "13.0.3";

  src = fetchzip {
    url = "https://web.archive.org/web/20200210125314/https://www.babelstone.co.uk/Fonts/Download/BabelStoneHan.zip";
    sha256 = "1k8n916x506wga3j8xacxgld2g2pxsr4mmb5cd1ix1mngfs4vf1c";
  };

  meta = with lib; {
    description = "Unicode CJK font with over 36000 Han characters";
    homepage = "https://www.babelstone.co.uk/Fonts/Han.html";

    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ volth emily ];
  };
}
