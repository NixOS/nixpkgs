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

  sysimg_armeabi-v7a_10 = buildSystemImage {
    name = "sysimg-armeabi-v7a-10";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/armv7-10_r04.zip;
      sha1 = "54680383118eb5c95a11e1cc2a14aa572c86ee69";
    };
  };

  sysimg_x86_10 = buildSystemImage {
    name = "sysimg-x86-10";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86-10_r04.zip;
      sha1 = "655ffc5cc89dd45a3aca154b254009016e473aeb";
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
      url = https://dl.google.com/android/repository/sys-img/android/armeabi-v7a-15_r04.zip;
      sha1 = "363223bd62f5afc0b2bd760b54ce9d26b31eacf1";
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
      url = https://dl.google.com/android/repository/sys-img/android/x86-15_r04.zip;
      sha1 = "e45c728b64881c0e86529a8f7ea9c103a3cd14c1";
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
      url = https://dl.google.com/android/repository/sys-img/android/x86-16_r05.zip;
      sha1 = "7ea16da3a8fdb880b1b290190fcc1bde2821c1e0";
    };
  };

  sysimg_armeabi-v7a_17 = buildSystemImage {
    name = "sysimg-armeabi-v7a-17";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/armeabi-v7a-17_r05.zip;
      sha1 = "7460e8110f4a87f9644f1bdb5511a66872d50fd9";
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
      url = https://dl.google.com/android/repository/sys-img/android/x86-17_r03.zip;
      sha1 = "eb30274460ff0d61f3ed37862b567811bebd8270";
    };
  };

  sysimg_armeabi-v7a_18 = buildSystemImage {
    name = "sysimg-armeabi-v7a-18";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/armeabi-v7a-18_r04.zip;
      sha1 = "0bf34ecf4ddd53f6b1b7fe7dfa12f2887c17e642";
    };
  };

  sysimg_x86_18 = buildSystemImage {
    name = "sysimg-x86-18";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86-18_r03.zip;
      sha1 = "03a0cb23465c3de15215934a1dbc9715b56e9458";
    };
  };

  sysimg_armeabi-v7a_19 = buildSystemImage {
    name = "sysimg-armeabi-v7a-19";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/armeabi-v7a-19_r05.zip;
      sha1 = "d1a5fd4f2e1c013c3d3d9bfe7e9db908c3ed56fa";
    };
  };

  sysimg_x86_19 = buildSystemImage {
    name = "sysimg-x86-19";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86-19_r06.zip;
      sha1 = "2ac82153aae97f7eae4c5a0761224fe04321d03d";
    };
  };

  sysimg_armeabi-v7a_21 = buildSystemImage {
    name = "sysimg-armeabi-v7a-21";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/armeabi-v7a-21_r04.zip;
      sha1 = "8c606f81306564b65e41303d2603e4c42ded0d10";
    };
  };

  sysimg_x86_21 = buildSystemImage {
    name = "sysimg-x86-21";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86-21_r05.zip;
      sha1 = "00f0eb0a1003efe3316347f762e20a85d8749cff";
    };
  };

  sysimg_x86_64_21 = buildSystemImage {
    name = "sysimg-x86_64-21";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86_64-21_r05.zip;
      sha1 = "9078a095825a69e5e215713f0866c83cef65a342";
    };
  };

  sysimg_armeabi-v7a_22 = buildSystemImage {
    name = "sysimg-armeabi-v7a-22";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/armeabi-v7a-22_r02.zip;
      sha1 = "2114ec015dbf3a16cbcb4f63e8a84a1b206a07a1";
    };
  };

  sysimg_x86_22 = buildSystemImage {
    name = "sysimg-x86-22";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86-22_r06.zip;
      sha1 = "e33e2a6cc3f1cc56b2019dbef3917d2eeb26f54e";
    };
  };

  sysimg_x86_64_22 = buildSystemImage {
    name = "sysimg-x86_64-22";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86_64-22_r06.zip;
      sha1 = "5db3b27f78cd9c4c5092b1cad5a5dd479fb5b2e4";
    };
  };

  sysimg_armeabi-v7a_23 = buildSystemImage {
    name = "sysimg-armeabi-v7a-23";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/armeabi-v7a-23_r06.zip;
      sha1 = "7cf2ad756e54a3acfd81064b63cb0cb9dff2798d";
    };
  };

  sysimg_x86_23 = buildSystemImage {
    name = "sysimg-x86-23";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86-23_r10.zip;
      sha1 = "f6c3e3dd7bd951454795aa75c3a145fd05ac25bb";
    };
  };

  sysimg_x86_64_23 = buildSystemImage {
    name = "sysimg-x86_64-23";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86_64-23_r10.zip;
      sha1 = "7cbc291483ca07dc67b71268c5f08a5755f50f51";
    };
  };

  sysimg_arm64-v8a_24 = buildSystemImage {
    name = "sysimg-arm64-v8a-24";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/arm64-v8a-24_r07.zip;
      sha1 = "e8ab2e49e4efe4b064232b33b5eeaded61437d7f";
    };
  };

  sysimg_armeabi-v7a_24 = buildSystemImage {
    name = "sysimg-armeabi-v7a-24";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/armeabi-v7a-24_r07.zip;
      sha1 = "3454546b4eed2d6c3dd06d47757d6da9f4176033";
    };
  };

  sysimg_x86_24 = buildSystemImage {
    name = "sysimg-x86-24";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86-24_r08.zip;
      sha1 = "c1cae7634b0216c0b5990f2c144eb8ca948e3511";
    };
  };

  sysimg_x86_64_24 = buildSystemImage {
    name = "sysimg-x86_64-24";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86_64-24_r08.zip;
      sha1 = "f6559e1949a5879f31a9662f4f0e50ad60181684";
    };
  };

  sysimg_x86_25 = buildSystemImage {
    name = "sysimg-x86-25";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86-25_r03.zip;
      sha1 = "7dd19cfee4e43a1f60e0f5f058404d92d9544b33";
    };
  };

  sysimg_x86_64_25 = buildSystemImage {
    name = "sysimg-x86_64-25";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/android/x86_64-25_r03.zip;
      sha1 = "4593ee04811df21c339f3374fc5917843db06f8d";
    };
  };
}

