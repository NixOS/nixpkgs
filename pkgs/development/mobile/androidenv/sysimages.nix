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
    
  sysimg_armeabi-v7a_20 = buildSystemImage {
    name = "sysimg-armeabi-v7a-20";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_armv7a-L_r01.zip;
      sha1 = "1d5d81a7078b5b2a685620d93e1e04a51d2e786a";
    };
  };
    
  sysimg_x86_20 = buildSystemImage {
    name = "sysimg-x86-20";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/android/sysimg_x86-L_r01.zip;
      sha1 = "c2d32d6244821ff59f370469778525f6a5345010";
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
