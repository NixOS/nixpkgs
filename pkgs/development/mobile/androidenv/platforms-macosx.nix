
# This file is generated from generate-platforms.sh. DO NOT EDIT.
# Execute generate-platforms.sh or fetch.sh to update the file.
{stdenv, fetchurl, unzip}:

let
  buildPlatform = args:
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
    
  platform_2 = buildPlatform {
    name = "android-platform-1.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-1.1_r1-macosx.zip;
      sha1 = "e21dbcff45b7356657449ebb3c7e941be2bb5ebe";
    };
    meta = {
      description = "Android SDK Platform 2";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_3 = buildPlatform {
    name = "android-platform-1.5";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-1.5_r04-macosx.zip;
      sha1 = "d3a67c2369afa48b6c3c7624de5031c262018d1e";
    };
    meta = {
      description = "Android SDK Platform 3";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_4 = buildPlatform {
    name = "android-platform-1.6";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-1.6_r03-macosx.zip;
      sha1 = "bdafad44f5df9f127979bdb21a1fdd87ee3cd625";
    };
    meta = {
      description = "Android SDK Platform 4";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_5 = buildPlatform {
    name = "android-platform-2.0";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-2.0_r01-macosx.zip;
      sha1 = "2a866d0870dbba18e0503cd41e5fae988a21b314";
    };
    meta = {
      description = "Android SDK Platform 5";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_6 = buildPlatform {
    name = "android-platform-2.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-2.0.1_r01-macosx.zip;
      sha1 = "c3096f80d75a6fc8cb38ef8a18aec920e53d42c0";
    };
    meta = {
      description = "Android SDK Platform 6";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_7 = buildPlatform {
    name = "android-platform-2.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-2.1_r03.zip;
      sha1 = "5ce51b023ac19f8738500b1007a1da5de2349a1e";
    };
    meta = {
      description = "Android SDK Platform 7";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_8 = buildPlatform {
    name = "android-platform-2.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-2.2_r03.zip;
      sha1 = "231262c63eefdff8fd0386e9ccfefeb27a8f9202";
    };
    meta = {
      description = "Android SDK Platform 8";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_9 = buildPlatform {
    name = "android-platform-2.3.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-2.3.1_r02.zip;
      sha1 = "209f8a7a8b2cb093fce858b8b55fed3ba5206773";
    };
    meta = {
      description = "Android SDK Platform 9";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_10 = buildPlatform {
    name = "android-platform-2.3.3";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-2.3.3_r02.zip;
      sha1 = "887e37783ec32f541ea33c2c649dda648e8e6fb3";
    };
    meta = {
      description = "Android SDK Platform 10";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_11 = buildPlatform {
    name = "android-platform-3.0";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-3.0_r02.zip;
      sha1 = "2c7d4bd13f276e76f6bbd87315fe27aba351dd37";
    };
    meta = {
      description = "Android SDK Platform 11";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_12 = buildPlatform {
    name = "android-platform-3.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-3.1_r03.zip;
      sha1 = "4a50a6679cd95bb68bb5fc032e754cd7c5e2b1bf";
    };
    meta = {
      description = "Android SDK Platform 12";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_13 = buildPlatform {
    name = "android-platform-3.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-3.2_r01.zip;
      sha1 = "6189a500a8c44ae73a439604363de93591163cd9";
    };
    meta = {
      description = "Android SDK Platform 13";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_14 = buildPlatform {
    name = "android-platform-4.0";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-14_r04.zip;
      sha1 = "d4f1d8fbca25225b5f0e7a0adf0d39c3d6e60b3c";
    };
    meta = {
      description = "Android SDK Platform 14";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_15 = buildPlatform {
    name = "android-platform-4.0.3";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-15_r05.zip;
      sha1 = "69ab4c443b37184b2883af1fd38cc20cbeffd0f3";
    };
    meta = {
      description = "Android SDK Platform 15";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_16 = buildPlatform {
    name = "android-platform-4.1.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-16_r05.zip;
      sha1 = "12a5ce6235a76bc30f62c26bda1b680e336abd07";
    };
    meta = {
      description = "Android SDK Platform 16";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_17 = buildPlatform {
    name = "android-platform-4.2.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-17_r03.zip;
      sha1 = "dbe14101c06e6cdb34e300393e64e64f8c92168a";
    };
    meta = {
      description = "Android SDK Platform 17";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_18 = buildPlatform {
    name = "android-platform-4.3.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-18_r03.zip;
      sha1 = "e6b09b3505754cbbeb4a5622008b907262ee91cb";
    };
    meta = {
      description = "Android SDK Platform 18";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_19 = buildPlatform {
    name = "android-platform-4.4.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-19_r04.zip;
      sha1 = "2ff20d89e68f2f5390981342e009db5a2d456aaa";
    };
    meta = {
      description = "Android SDK Platform 19";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_20 = buildPlatform {
    name = "android-platform-4.4W.2";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-20_r02.zip;
      sha1 = "a9251f8a3f313ab05834a07a963000927637e01d";
    };
    meta = {
      description = "Android SDK Platform 20";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_21 = buildPlatform {
    name = "android-platform-5.0.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-21_r02.zip;
      sha1 = "53536556059bb29ae82f414fd2e14bc335a4eb4c";
    };
    meta = {
      description = "Android SDK Platform 21";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_22 = buildPlatform {
    name = "android-platform-5.1.1";
    src = fetchurl {
      url = https://dl.google.com/android/repository/android-22_r02.zip;
      sha1 = "5d1bd10fea962b216a0dece1247070164760a9fc";
    };
    meta = {
      description = "Android SDK Platform 22";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_23 = buildPlatform {
    name = "android-platform-6.0";
    src = fetchurl {
      url = https://dl.google.com/android/repository/platform-23_r03.zip;
      sha1 = "027fede3de6aa1649115bbd0bffff30ccd51c9a0";
    };
    meta = {
      description = "Android SDK Platform 23";
      url = http://developer.android.com/sdk/;
    };
  };

  platform_24 = buildPlatform {
    name = "android-platform-7.0";
    src = fetchurl {
      url = https://dl.google.com/android/repository/platform-24_r01.zip;
      sha1 = "27516dab4848f55896e16f7089038c62bbbffea7";
    };
    meta = {
      description = "Android SDK Platform 24";
      url = http://developer.android.com/sdk/;
    };
  };

}
