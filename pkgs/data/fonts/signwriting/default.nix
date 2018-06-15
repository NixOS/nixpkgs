{ lib, runCommand, fetchurl }:

runCommand "signwriting-1.1.4" {
  src1 = fetchurl {
    url = "https://github.com/Slevinski/signwriting_2010_fonts/raw/61c8e7123a1168657b5d34d85266a637f67b9d2b/fonts/SignWriting%202010.ttf";
    name = "SignWriting_2010.ttf";
    sha256 = "1abjzykbjx2hal8mrxp51rvblv3q84akyn9qhjfaj20rwphkf5zj";
  };

  src2 = fetchurl {
    url = "https://github.com/Slevinski/signwriting_2010_fonts/raw/61c8e7123a1168657b5d34d85266a637f67b9d2b/fonts/SignWriting%202010%20Filling.ttf";
    name = "SignWriting_2010_Filling.ttf";
    sha256 = "0am5wbf7jdy9szxkbsc5f3959cxvbj7mr0hy1ziqmkz02c6xjw2m";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0cn37s3lc7gbr8036l7ia2869qmxglkmgllh3r9q5j54g3sfjc7q";

  meta = with lib; {
    homepage = https://github.com/Slevinski/signwriting_2010_fonts;
    description = "Typeface for written sign languages";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
''
  mkdir -p $out/share/fonts/truetype
  cp $src1 $out/share/fonts/truetype/SignWriting_2010.ttf
  cp $src2 $out/share/fonts/truetype/SignWriting_2010_Filling.ttf
''
