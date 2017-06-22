
# This file is generated from generate-sources.sh. DO NOT EDIT.
# Execute generate-sources.sh or fetch.sh to update the file.
{stdenv, fetchurl, unzip}:

let
  buildSource = args:
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

  source_14 = buildSource {
    name = "android-source-14";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-14_r01.zip;
      sha1 = "eaf4ed7dcac46e68516a1b4aa5b0d9e5a39a7555";
    };
    meta = {
      description = "Source code for Android API 14";
    };
  };

  source_15 = buildSource {
    name = "android-source-15";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-15_r02.zip;
      sha1 = "e5992a5747c9590783fbbdd700337bf0c9f6b1fa";
    };
    meta = {
      description = "Source code for Android API 15";
    };
  };

  source_16 = buildSource {
    name = "android-source-16";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-16_r02.zip;
      sha1 = "0f83c14ed333c45d962279ab5d6bc98a0269ef84";
    };
    meta = {
      description = "Source code for Android API 16";
    };
  };

  source_17 = buildSource {
    name = "android-source-17";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-17_r01.zip;
      sha1 = "6f1f18cd2d2b1852d7f6892df9cee3823349d43a";
    };
    meta = {
      description = "Source code for Android API 17";
    };
  };

  source_18 = buildSource {
    name = "android-source-18";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-18_r01.zip;
      sha1 = "8b49fdf7433f4881a2bfb559b5dd05d8ec65fb78";
    };
    meta = {
      description = "Source code for Android API 18";
    };
  };

  source_19 = buildSource {
    name = "android-source-19";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-19_r02.zip;
      sha1 = "433a1d043ef77561571250e94cb7a0ef24a202e7";
    };
    meta = {
      description = "Source code for Android API 19";
    };
  };

  source_20 = buildSource {
    name = "android-source-20";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-20_r01.zip;
      sha1 = "8da3e40f2625f9f7ef38b7e403f49f67226c0d76";
    };
    meta = {
      description = "Source code for Android API 20";
    };
  };

  source_21 = buildSource {
    name = "android-source-21";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-21_r01.zip;
      sha1 = "137a5044915d32bea297a8c1552684802bbc2e25";
    };
    meta = {
      description = "Source code for Android API 21";
    };
  };

  source_22 = buildSource {
    name = "android-source-22";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-22_r01.zip;
      sha1 = "98320e13976d11597a4a730a8d203ac9a03ed5a6";
    };
    meta = {
      description = "Source code for Android API 22";
    };
  };

  source_23 = buildSource {
    name = "android-source-23";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-23_r01.zip;
      sha1 = "b0f15da2762b42f543c5e364c2b15b198cc99cc2";
    };
    meta = {
      description = "Source code for Android API 23";
    };
  };

  source_24 = buildSource {
    name = "android-source-24";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-24_r01.zip;
      sha1 = "6b96115830a83d654479f32ce4b724ca9011148b";
    };
    meta = {
      description = "Source code for Android API 24";
    };
  };

  source_25 = buildSource {
    name = "android-source-25";
    src = fetchurl {
      url = https://dl.google.com/android/repository/sources-25_r01.zip;
      sha1 = "bbc72efd1a9bad87cc507e308f0d29aad438c52c";
    };
    meta = {
      description = "Source code for Android API 25";
    };
  };

}
