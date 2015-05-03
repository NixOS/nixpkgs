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

  sysimg_armeabi-v7a_14 = buildSystemImage {
    name = "sysimg-armeabi-v7a-14";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_armv7a-14_r02.zip;
      sha1 = "d8991b0c06b18d7d6ed4169d67460ee1add6661b";
    };
  };

  sysimg_armeabi-v7a_15 = buildSystemImage {
    name = "sysimg-armeabi-v7a-15";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_armv7a-15_r02.zip;
      sha1 = "1bf977d6cb4e0ad38dceac0c4863d1caa21f326e";
    };
  };

  sysimg_armeabi-v7a_16 = buildSystemImage {
    name = "sysimg-armeabi-v7a-16";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_armv7a-16_r03.zip;
      sha1 = "d1cddb23f17aad5821a089c403d4cddad2cf9ef7";
    };
  };

  sysimg_armeabi-v7a_17 = buildSystemImage {
    name = "sysimg-armeabi-v7a-17";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_armv7a-17_r02.zip;
      sha1 = "1c321cda1af793b84d47d1a8d15f85444d265e3c";
    };
  };

  sysimg_armeabi-v7a_18 = buildSystemImage {
    name = "sysimg-armeabi-v7a-18";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_armv7a-18_r02.zip;
      sha1 = "4a1a93200210d8c42793324362868846f67401ab";
    };
  };

  sysimg_armeabi-v7a_19 = buildSystemImage {
    name = "sysimg-armeabi-v7a-19";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_armv7a-19_r02.zip;
      sha1 = "e0d375397e28e3d5d9577a00132463a4696248e5";
    };
  };

  sysimg_armeabi-v7a_21 = buildSystemImage {
    name = "sysimg-armeabi-v7a-21";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_arm-21_r03.zip;
      sha1 = "0b2e21421d29f48211b5289ca4addfa7f4c7ae5a";
    };
  };

  sysimg_x86_10 = buildSystemImage {
    name = "sysimg-x86-10";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_x86-10_r02.zip;
      sha1 = "34e2436f69606cdfe35d3ef9112f0c64e3ff021d";
    };
  };

  sysimg_x86_15 = buildSystemImage {
    name = "sysimg-x86-15";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_x86-15_r01.zip;
      sha1 = "d540325952e0f097509622b9e685737584b83e40";
    };
  };

  sysimg_x86_16 = buildSystemImage {
    name = "sysimg-x86-16";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_x86-16_r01.zip;
      sha1 = "9d35bcaa4f9b40443941f32b8a50337f413c021a";
    };
  };

  sysimg_x86_17 = buildSystemImage {
    name = "sysimg-x86-17";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_x86-17_r01.zip;
      sha1 = "ddb3313e8dcd07926003f7b828eafea1115ea35b";
    };
  };

  sysimg_x86_18 = buildSystemImage {
    name = "sysimg-x86-18";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_x86-18_r01.zip;
      sha1 = "f11bc9fccd3e7e46c07d8b26e112a8d0b45966c1";
    };
  };

  sysimg_x86_19 = buildSystemImage {
    name = "sysimg-x86-19";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_x86-19_r02.zip;
      sha1 = "8889cb418984a2a7916a359da7c429d2431ed060";
    };
  };

  sysimg_x86_21 = buildSystemImage {
    name = "sysimg-x86-21";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_x86-21_r03.zip;
      sha1 = "a0b510c66769e84fa5e40515531be2d266a4247f";
    };
  };

  sysimg_x86_64_21 = buildSystemImage {
    name = "sysimg-x86_64-21";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_x86_64-21_r03.zip;
      sha1 = "2f205b728695d84488156f4846beb83a353ea64b";
    };
  };

  sysimg_x86_22 = buildSystemImage {
    name = "sysimg-x86-22";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_x86-22_r01.zip;
      sha1 = "6c7bb51e41a16099bb1f2a3cc81fdb5aa053fc15";
    };
  };

  sysimg_x86_64_22 = buildSystemImage {
    name = "sysimg-x86_64-22";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_x86_64-22_r01.zip;
      sha1 = "05752813603f9fa03a58dcf7f8f5e779be722aae";
    };
  };

  sysimg_armeabi-v7a_22 = buildSystemImage {
    name = "sysimg-armeabi-v7a-22";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_arm-22_r01.zip;
      sha1 = "2aa6a887ee75dcf3ac34627853d561997792fcb8";
    };
  };

  sysimg_mips_15 = buildSystemImage {
    name = "sysimg-mips-15";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_mips-15_r01.zip;
      sha1 = "a753bb4a6783124dad726c500ce9aec9d2c1b2d9";
    };
  };

  sysimg_mips_16 = buildSystemImage {
    name = "sysimg-mips-16";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_mips-16_r04.zip;
      sha1 = "67943c54fb3943943ffeb05fdd39c0b753681f6e";
    };
  };

  sysimg_mips_17 = buildSystemImage {
    name = "sysimg-mips-17";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_mips-17_r01.zip;
      sha1 = "f0c6e153bd584c29e51b5c9723cfbf30f996a05d";
    };
  };
}
