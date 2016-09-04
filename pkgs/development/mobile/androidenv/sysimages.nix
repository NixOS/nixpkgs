# This file is generated from generate-sysimages.sh. DO NOT EDIT.
# Execute generate-sysimages.sh or fetch.sh to update the file.
{stdenv, fetchurl, unzip}:

let
  buildSystemImage = args:
    stdenv.mkDerivation (args // {
      buildInputs = [ unzip ];
      buildCommand = ''
        mkdir -p $out
        cd $out
        unzip $src
    '';
  });
in
{

  sysimg_x86_10 = buildSystemImage {
    name = "sysimg-x86-10";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86-10_r03.zip;
      sha1 = "6b8539eaca9685d2d3289bf8e6d21d366d791326";
    };
  };

  sysimg_armeabi-v7a_14 = buildSystemImage {
    name = "sysimg-armeabi-v7a-14";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_armv7a-14_r02.zip;
      sha1 = "d8991b0c06b18d7d6ed4169d67460ee1add6661b";
    };
  };

  sysimg_armeabi-v7a_15 = buildSystemImage {
    name = "sysimg-armeabi-v7a-15";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_armv7a-15_r03.zip;
      sha1 = "0a47f586e172b1cf3db2ada857a70c2bdec24ef8";
    };
  };

  sysimg_mips_15 = buildSystemImage {
    name = "sysimg-mips-15";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_mips-15_r01.zip;
      sha1 = "a753bb4a6783124dad726c500ce9aec9d2c1b2d9";
    };
  };

  sysimg_x86_15 = buildSystemImage {
    name = "sysimg-x86-15";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86-15_r02.zip;
      sha1 = "56b8d4b3d0f6a8876bc78d654da186f3b7b7c44f";
    };
  };

  sysimg_armeabi-v7a_16 = buildSystemImage {
    name = "sysimg-armeabi-v7a-16";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_armv7a-16_r04.zip;
      sha1 = "39c093ea755098f0ee79f607be7df9e54ba4943f";
    };
  };

  sysimg_mips_16 = buildSystemImage {
    name = "sysimg-mips-16";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_mips-16_r04.zip;
      sha1 = "67943c54fb3943943ffeb05fdd39c0b753681f6e";
    };
  };

  sysimg_x86_16 = buildSystemImage {
    name = "sysimg-x86-16";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86-16_r02.zip;
      sha1 = "36c2a2e394bcb3290583ce09815eae7711d0b2c2";
    };
  };

  sysimg_armeabi-v7a_17 = buildSystemImage {
    name = "sysimg-armeabi-v7a-17";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_armv7a-17_r03.zip;
      sha1 = "97cfad22b51c8475e228b207dd36dbef1c18fa38";
    };
  };

  sysimg_mips_17 = buildSystemImage {
    name = "sysimg-mips-17";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_mips-17_r01.zip;
      sha1 = "f0c6e153bd584c29e51b5c9723cfbf30f996a05d";
    };
  };

  sysimg_x86_17 = buildSystemImage {
    name = "sysimg-x86-17";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86-17_r02.zip;
      sha1 = "bd8c7c5411431af7e051cbe961be430fc31e773d";
    };
  };

  sysimg_armeabi-v7a_18 = buildSystemImage {
    name = "sysimg-armeabi-v7a-18";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_armv7a-18_r03.zip;
      sha1 = "2d7d51f4d2742744766511e5d6b491bd49161c51";
    };
  };

  sysimg_x86_18 = buildSystemImage {
    name = "sysimg-x86-18";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86-18_r02.zip;
      sha1 = "ab3de121a44fca43ac3aa83f7d68cc47fc643ee8";
    };
  };

  sysimg_armeabi-v7a_19 = buildSystemImage {
    name = "sysimg-armeabi-v7a-19";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_armv7a-19_r03.zip;
      sha1 = "5daf7718e3ab03d9bd8792b492dd305f386ef12f";
    };
  };

  sysimg_x86_19 = buildSystemImage {
    name = "sysimg-x86-19";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86-19_r05.zip;
      sha1 = "c9298a8eafceed3b8fa11071ba63a3d18e17fd8e";
    };
  };

  sysimg_armeabi-v7a_21 = buildSystemImage {
    name = "sysimg-armeabi-v7a-21";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_arm-21_r03.zip;
      sha1 = "0b2e21421d29f48211b5289ca4addfa7f4c7ae5a";
    };
  };

  sysimg_x86_21 = buildSystemImage {
    name = "sysimg-x86-21";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86-21_r04.zip;
      sha1 = "3b78ad294aa1cdefa4be663d4af6c80d920ec49e";
    };
  };

  sysimg_x86_64_21 = buildSystemImage {
    name = "sysimg-x86_64-21";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86_64-21_r04.zip;
      sha1 = "eb14ba9c14615d5e5a21c854be29aa903d9bb63d";
    };
  };

  sysimg_armeabi-v7a_22 = buildSystemImage {
    name = "sysimg-armeabi-v7a-22";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_arm-22_r01.zip;
      sha1 = "2aa6a887ee75dcf3ac34627853d561997792fcb8";
    };
  };

  sysimg_x86_22 = buildSystemImage {
    name = "sysimg-x86-22";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86-22_r05.zip;
      sha1 = "909e0ad91ed43381597e82f65ec93d41f049dd53";
    };
  };

  sysimg_x86_64_22 = buildSystemImage {
    name = "sysimg-x86_64-22";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86_64-22_r05.zip;
      sha1 = "8a04ff4fb30f70414e6ec7b3b06285f316e93d08";
    };
  };

  sysimg_armeabi-v7a_23 = buildSystemImage {
    name = "sysimg-armeabi-v7a-23";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_arm-23_r03.zip;
      sha1 = "7bb8768ec4333500192fd9627d4234f505fa98dc";
    };
  };

  sysimg_x86_23 = buildSystemImage {
    name = "sysimg-x86-23";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86-23_r09.zip;
      sha1 = "0ce9229974818179833899dce93f228a895ec6a2";
    };
  };

  sysimg_x86_64_23 = buildSystemImage {
    name = "sysimg-x86_64-23";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86_64-23_r09.zip;
      sha1 = "571f5078a3d337a9144e2af13bd23ca46845a979";
    };
  };

  sysimg_armeabi-v7a_24 = buildSystemImage {
    name = "sysimg-armeabi-v7a-24";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_armeabi-v7a-24_r05.zip;
      sha1 = "2eb8fb86f7312614a2a0b033d669d67206a618ff";
    };
  };

  sysimg_x86_24 = buildSystemImage {
    name = "sysimg-x86-24";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86-24_r05.zip;
      sha1 = "ce6441c4cadaecd28b364c59b36c31ef0904dae0";
    };
  };

  sysimg_x86_64_24 = buildSystemImage {
    name = "sysimg-x86_64-24";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/sysimg_x86_64-24_r05.zip;
      sha1 = "e1869b32b1dcb2f4d4d18c912166b3e2bee8a841";
    };
  };
}
