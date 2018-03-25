
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
      url = https://dl.google.com/android/repository/build-tools_r26.0.1-macosx.zip;
      sha1 = "cbde59de198916b390777dd0227921bfa2120832";
    };
  };

  buildTools_26 = buildToolsFor rec {
    version = "26";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r26-macosx.zip;
      sha1 = "d01a1aeca03747245f1f5936b3cb01759c66d086";
    };
  };

  buildTools_26-rc2 = buildToolsFor rec {
    version = "26-rc2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r26-rc2-macosx.zip;
      sha1 = "cb1eb738a1f7003025af267a9b8cc2d259533c70";
    };
  };

  buildTools_26-rc1 = buildToolsFor rec {
    version = "26-rc1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r26-rc1-macosx.zip;
      sha1 = "5c5a1de7d5f4f000d36ae349229fe0be846d6137";
    };
  };

  buildTools_25_0_3 = buildToolsFor rec {
    version = "25.0.3";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r25.0.3-macosx.zip;
      sha1 = "160d2fefb5ce68e443427fc30a793a703b63e26e";
    };
  };

  buildTools_25_0_2 = buildToolsFor rec {
    version = "25.0.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r25.0.2-macosx.zip;
      sha1 = "12a5204bb3b6e39437535469fde7ddf42da46b16";
    };
  };

  buildTools_25_0_1 = buildToolsFor rec {
    version = "25.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r25.0.1-macosx.zip;
      sha1 = "7bf7f22d7d48ef20b6ab0e3d7a2912e5c088340f";
    };
  };

  buildTools_25 = buildToolsFor rec {
    version = "25";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r25-macosx.zip;
      sha1 = "273c5c29a65cbed00e44f3aa470bbd7dce556606";
    };
  };

  buildTools_24_0_3 = buildToolsFor rec {
    version = "24.0.3";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r24.0.3-macosx.zip;
      sha1 = "a01c15f1b105c34595681075e1895d58b3fff48c";
    };
  };

  buildTools_24_0_2 = buildToolsFor rec {
    version = "24.0.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r24.0.2-macosx.zip;
      sha1 = "8bb8fc575477491d5957de743089df412de55cda";
    };
  };

  buildTools_24_0_1 = buildToolsFor rec {
    version = "24.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r24.0.1-macosx.zip;
      sha1 = "5c6457fcdfa07724fb086d8ff4e8316fc0742848";
    };
  };

  buildTools_24 = buildToolsFor rec {
    version = "24";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r24-macosx.zip;
      sha1 = "97fc4ed442f23989cc488d02c1d1de9bdde241de";
    };
  };

  buildTools_23_0_2 = buildToolsFor rec {
    version = "23.0.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r23.0.2-macosx.zip;
      sha1 = "482c4cbceef8ff58aefd92d8155a38610158fdaf";
    };
  };

  buildTools_23_0_3 = buildToolsFor rec {
    version = "23.0.3";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r23.0.3-macosx.zip;
      sha1 = "fbc98cd303fd15a31d472de6c03bd707829f00b0";
    };
  };

  buildTools_23_0_1 = buildToolsFor rec {
    version = "23.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r23.0.1-macosx.zip;
      sha1 = "d96ec1522721e9a179ae2c591c99f75d31d39718";
    };
  };

  buildTools_23 = buildToolsFor rec {
    version = "23";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r23-macosx.zip;
      sha1 = "90ba6e716f7703a236cd44b2e71c5ff430855a03";
    };
  };

  buildTools_22_0_1 = buildToolsFor rec {
    version = "22.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r22.0.1-macosx.zip;
      sha1 = "53dad7f608e01d53b17176ba11165acbfccc5bbf";
    };
  };

  buildTools_22 = buildToolsFor rec {
    version = "22";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r22-macosx.zip;
      sha1 = "af95429b24088d704bc5db9bd606e34ac1b82c0d";
    };
  };

  buildTools_21_1_2 = buildToolsFor rec {
    version = "21.1.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21.1.2-macosx.zip;
      sha1 = "e7c906b4ba0eea93b32ba36c610dbd6b204bff48";
    };
  };

  buildTools_21_1_1 = buildToolsFor rec {
    version = "21.1.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21.1.1-macosx.zip;
      sha1 = "836a146eab0504aa9387a5132e986fe7c7381571";
    };
  };

  buildTools_21_1 = buildToolsFor rec {
    version = "21.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21.1-macosx.zip;
      sha1 = "df619356c2359aa5eacdd48699d15b335d9bd246";
    };
  };

  buildTools_21_0_2 = buildToolsFor rec {
    version = "21.0.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21.0.2-macosx.zip;
      sha1 = "f17471c154058f3734729ef3cc363399b1cd3de1";
    };
  };

  buildTools_21_0_1 = buildToolsFor rec {
    version = "21.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21.0.1-macosx.zip;
      sha1 = "b60c8f9b810c980abafa04896706f3911be1ade7";
    };
  };

  buildTools_21 = buildToolsFor rec {
    version = "21";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r21-macosx.zip;
      sha1 = "9bef7989b51436bd4e5114d8a0330359f077cbfa";
    };
  };

  buildTools_20 = buildToolsFor rec {
    version = "20";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r20-macosx.zip;
      sha1 = "1240f629411c108a714c4ddd756937c7fab93f83";
    };
  };

  buildTools_19_1 = buildToolsFor rec {
    version = "19.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r19.1-macosx.zip;
      sha1 = "0d11aae3417de1efb4b9a0e0a7855904a61bcec1";
    };
  };

  buildTools_19_0_3 = buildToolsFor rec {
    version = "19.0.3";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r19.0.3-macosx.zip;
      sha1 = "651cf8754373b2d52e7f6aab2c52eabffe4e9ea4";
    };
  };

  buildTools_19_0_2 = buildToolsFor rec {
    version = "19.0.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r19.0.2-macosx.zip;
      sha1 = "145bc43065d45f756d99d87329d899052b9a9288";
    };
  };

  buildTools_19_0_1 = buildToolsFor rec {
    version = "19.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r19.0.1-macosx.zip;
      sha1 = "efaf50fb19a3edb8d03efbff76f89a249ad2920b";
    };
  };

  buildTools_19 = buildToolsFor rec {
    version = "19";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r19-macosx.zip;
      sha1 = "86ec1c12db1bc446b7bcaefc5cc14eb361044e90";
    };
  };

  buildTools_18_1_1 = buildToolsFor rec {
    version = "18.1.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r18.1.1-macosx.zip;
      sha1 = "a9d9d37f6ddf859e57abc78802a77aaa166e48d4";
    };
  };

  buildTools_18_1 = buildToolsFor rec {
    version = "18.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r18.1-macosx.zip;
      sha1 = "16ddb299b8b43063e5bb3387ec17147c5053dfd8";
    };
  };

  buildTools_18_0_1 = buildToolsFor rec {
    version = "18.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r18.0.1-macosx.zip;
      sha1 = "d84f5692fb44d60fc53e5b2507cebf9f24626902";
    };
  };

  buildTools_17 = buildToolsFor rec {
    version = "17";
    src = fetchurl {
      url = https://dl.google.com/android/repository/build-tools_r17-macosx.zip;
      sha1 = "602ee709be9dbb8f179b1e4075148a57f9419930";
    };
  };

}
