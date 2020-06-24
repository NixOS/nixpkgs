{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "migmix";
  version = "20150712";

  srcs = [
    (fetchzip {
      name = "migmix-1p-${version}.zip";
      url = "mirror://osdn/mix-mplus-ipa/63544/migmix-1p-${version}.zip";
      sha256 = "0wp44axcalaak04nj3dgpx0vk13nqa3ihx2vjv4acsgv83x8ciph";
    })
    (fetchzip {
      name = "migmix-2p-${version}.zip";
      url = "mirror://osdn/mix-mplus-ipa/63544/migmix-2p-${version}.zip";
      sha256 = "0y7s3rbxrp5bv56qgihk8b847lqgibfhn2wlkzx7z655fbzdgxw9";
    })
    (fetchzip {
      name = "migmix-1m-${version}.zip";
      url = "mirror://osdn/mix-mplus-ipa/63544/migmix-1m-${version}.zip";
      sha256 = "1sfym0chy8ilyd9sr3mjc0bf63vc33p05ynpdc11miivxn4qsshx";
    })
    (fetchzip {
      name = "migmix-2m-${version}.zip";
      url = "mirror://osdn/mix-mplus-ipa/63544/migmix-2m-${version}.zip";
      sha256 = "0hg04rvm39fh4my4akmv4rhfc14s3ipz2aw718h505k9hppkhkch";
    })
  ];

  meta = with lib; {
    description = "A high-quality Japanese font based on M+ fonts and IPA fonts";
    homepage = "http://mix-mplus-ipa.osdn.jp/migmix";
    license = licenses.ipa;
    maintainers = [ maintainers.mikoim ];
  };
}
