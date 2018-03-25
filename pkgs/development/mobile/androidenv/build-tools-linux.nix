
# This file is generated from generate-build-tools.sh. DO NOT EDIT.
# Execute generate-build-tools.sh or fetch.sh to update the file.
{stdenv, stdenv_32bit, fetchurl, unzip, zlib_32bit, ncurses_32bit, file, zlib, ncurses}@args:

let
  buildToolsFor = import ./build-tools.nix args;
in
{

  buildTools_26_0_1 = buildToolsFor rec {
    version = "26.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r26.0.1-linux.zip;
      sha1 = "5378c2c78091b414d0eac40a6bd37f2faa31a365";
    };
  };

  buildTools_26 = buildToolsFor rec {
    version = "26";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r26-linux.zip;
      sha1 = "1cbe72929876f8a872ab1f1b1040a9f720261f59";
    };
  };

  buildTools_26-rc2 = buildToolsFor rec {
    version = "26-rc2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r26-rc2-linux.zip;
      sha1 = "629bbd8d2e415bf64871fb0b4c0540fd6d0347a0";
    };
  };

  buildTools_26-rc1 = buildToolsFor rec {
    version = "26-rc1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r26-rc1-linux.zip;
      sha1 = "8cd6388dc96db2d7a49d06159cf990d3bbc78d04";
    };
  };

  buildTools_25_0_3 = buildToolsFor rec {
    version = "25.0.3";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r25.0.3-linux.zip;
      sha1 = "db95f3a0ae376534d4d69f4cdb6fad20649f3509";
    };
  };

  buildTools_25_0_2 = buildToolsFor rec {
    version = "25.0.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r25.0.2-linux.zip;
      sha1 = "ff953c0177e317618fda40516f3e9d95fd43c7ae";
    };
  };

  buildTools_25_0_1 = buildToolsFor rec {
    version = "25.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r25.0.1-linux.zip;
      sha1 = "ff063d252ab750d339f5947d06ff782836f22bac";
    };
  };

  buildTools_25 = buildToolsFor rec {
    version = "25";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r25-linux.zip;
      sha1 = "f2bbda60403e75cabd0f238598c3b4dfca56ea44";
    };
  };

  buildTools_24_0_3 = buildToolsFor rec {
    version = "24.0.3";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r24.0.3-linux.zip;
      sha1 = "9e8cc49d66e03fa1a8ecc1ac3e58f1324f5da304";
    };
  };

  buildTools_24_0_2 = buildToolsFor rec {
    version = "24.0.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r24.0.2-linux.zip;
      sha1 = "f199a7a788c3fefbed102eea34d6007737b803cf";
    };
  };

  buildTools_24_0_1 = buildToolsFor rec {
    version = "24.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r24.0.1-linux.zip;
      sha1 = "84f18c392919a074fcbb9b1d967984e6b2fef8b4";
    };
  };

  buildTools_24 = buildToolsFor rec {
    version = "24";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r24-linux.zip;
      sha1 = "c6271c4d78a5612ea6c7150688bcd5b7313de8d1";
    };
  };

  buildTools_23_0_2 = buildToolsFor rec {
    version = "23.0.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r23.0.2-linux.zip;
      sha1 = "8a9f2b37f6fcf7a9fa784dc21aeaeb41bbb9f2c3";
    };
  };

  buildTools_23_0_3 = buildToolsFor rec {
    version = "23.0.3";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r23.0.3-linux.zip;
      sha1 = "368f2600feac7e9b511b82f53d1f2240ae4a91a3";
    };
  };

  buildTools_23_0_1 = buildToolsFor rec {
    version = "23.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r23.0.1-linux.zip;
      sha1 = "b6ba7c399d5fa487d95289d8832e4ad943aed556";
    };
  };

  buildTools_23 = buildToolsFor rec {
    version = "23";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r23-linux.zip;
      sha1 = "c1d6209212b01469f80fa804e0c1d39a06bc9060";
    };
  };

  buildTools_22_0_1 = buildToolsFor rec {
    version = "22.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r22.0.1-linux.zip;
      sha1 = "da8b9c5c3ede39298e6cf0283c000c2ee9029646";
    };
  };

  buildTools_22 = buildToolsFor rec {
    version = "22";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r22-linux.zip;
      sha1 = "a8a1619dd090e44fac957bce6842e62abf87965b";
    };
  };

  buildTools_21_1_2 = buildToolsFor rec {
    version = "21.1.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21.1.2-linux.zip;
      sha1 = "5e35259843bf2926113a38368b08458735479658";
    };
  };

  buildTools_21_1_1 = buildToolsFor rec {
    version = "21.1.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21.1.1-linux.zip;
      sha1 = "1c712ee3a1ba5a8b0548f9c32f17d4a0ddfd727d";
    };
  };

  buildTools_21_1 = buildToolsFor rec {
    version = "21.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21.1-linux.zip;
      sha1 = "b7455e543784d52a8925f960bc880493ed1478cb";
    };
  };

  buildTools_21_0_2 = buildToolsFor rec {
    version = "21.0.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21.0.2-linux.zip;
      sha1 = "e1236ab8897b62b57414adcf04c132567b2612a5";
    };
  };

  buildTools_21_0_1 = buildToolsFor rec {
    version = "21.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21.0.1-linux.zip;
      sha1 = "e573069eea3e5255e7a65bedeb767f4fd0a5f49a";
    };
  };

  buildTools_21 = buildToolsFor rec {
    version = "21";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21-linux.zip;
      sha1 = "4933328fdeecbd554a29528f254f4993468e1cf4";
    };
  };

  buildTools_20 = buildToolsFor rec {
    version = "20";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r20-linux.zip;
      sha1 = "b688905526a5584d1327a662d871a635ff502758";
    };
  };

  buildTools_19_1 = buildToolsFor rec {
    version = "19.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r19.1-linux.zip;
      sha1 = "1ff20ac15fa47a75d00346ec12f180d531b3ca89";
    };
  };

  buildTools_19_0_3 = buildToolsFor rec {
    version = "19.0.3";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r19.0.3-linux.zip;
      sha1 = "c2d6055478e9d2d4fba476ee85f99181ddd1160c";
    };
  };

  buildTools_19_0_2 = buildToolsFor rec {
    version = "19.0.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r19.0.2-linux.zip;
      sha1 = "a03a6bdea0091aea32e1b35b90a7294c9f04e3dd";
    };
  };

  buildTools_19_0_1 = buildToolsFor rec {
    version = "19.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r19.0.1-linux.zip;
      sha1 = "18d2312dc4368858914213087f4e61445aca4517";
    };
  };

  buildTools_19 = buildToolsFor rec {
    version = "19";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r19-linux.zip;
      sha1 = "55c1a6cf632e7d346f0002b275ec41fd3137fd83";
    };
  };

  buildTools_18_1_1 = buildToolsFor rec {
    version = "18.1.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r18.1.1-linux.zip;
      sha1 = "68c9acbfc0cec2d51b19efaed39831a17055d998";
    };
  };

  buildTools_18_1 = buildToolsFor rec {
    version = "18.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r18.1-linux.zip;
      sha1 = "f314a0599e51397f0886fe888b50dd98f2f050d8";
    };
  };

  buildTools_18_0_1 = buildToolsFor rec {
    version = "18.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r18.0.1-linux.zip;
      sha1 = "f11618492b0d2270c332325d45d752d3656a9640";
    };
  };

  buildTools_17 = buildToolsFor rec {
    version = "17";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r17-linux.zip;
      sha1 = "2c2872bc3806aabf16a12e3959c2183ddc866e6d";
    };
  };

}
