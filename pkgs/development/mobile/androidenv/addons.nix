
# This file is generated from generate-addons.sh. DO NOT EDIT.
# Execute generate-addons.sh or fetch.sh to update the file.
{stdenv, fetchurl, unzip}:

let
  buildGoogleApis = args:
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

  google_apis_3 = buildGoogleApis {
    name = "google_apis-3";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-3-r03.zip;
        sha1 = "1f92abf3a76be66ae8032257fc7620acbd2b2e3a";
      };
      meta = {
        description = "Android + Google APIs";
        url = http://developer.android.com/;
      };
    };

  google_apis_4 = buildGoogleApis {
    name = "google_apis-4";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-4_r02.zip;
        sha1 = "9b6e86d8568558de4d606a7debc4f6049608dbd0";
      };
      meta = {
        description = "Android + Google APIs";
        url = http://developer.android.com/;
      };
    };

  google_apis_5 = buildGoogleApis {
    name = "google_apis-5";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-5_r01.zip;
        sha1 = "46eaeb56b645ee7ffa24ede8fa17f3df70db0503";
      };
      meta = {
        description = "Android + Google APIs";
        url = http://developer.android.com/;
      };
    };

  google_apis_6 = buildGoogleApis {
    name = "google_apis-6";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-6_r01.zip;
        sha1 = "5ff545d96e031e09580a6cf55713015c7d4936b2";
      };
      meta = {
        description = "Android + Google APIs";
        url = http://developer.android.com/;
      };
    };

  google_apis_7 = buildGoogleApis {
    name = "google_apis-7";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-7_r01.zip;
        sha1 = "2e7f91e0fe34fef7f58aeced973c6ae52361b5ac";
      };
      meta = {
        description = "Android + Google APIs";
        url = http://developer.android.com/;
      };
    };

  google_apis_8 = buildGoogleApis {
    name = "google_apis-8";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-8_r02.zip;
        sha1 = "3079958e7ec87222cac1e6b27bc471b27bf2c352";
      };
      meta = {
        description = "Android + Google APIs";
        url = http://developer.android.com/;
      };
    };

  google_apis_9 = buildGoogleApis {
    name = "google_apis-9";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-9_r02.zip;
        sha1 = "78664645a1e9accea4430814f8694291a7f1ea5d";
      };
      meta = {
        description = "Android + Google APIs";
        url = http://developer.android.com/;
      };
    };

  google_apis_10 = buildGoogleApis {
    name = "google_apis-10";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-10_r02.zip;
        sha1 = "cc0711857c881fa7534f90cf8cc09b8fe985484d";
      };
      meta = {
        description = "Android + Google APIs";
        url = http://developer.android.com/;
      };
    };

  google_apis_11 = buildGoogleApis {
    name = "google_apis-11";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-11_r01.zip;
        sha1 = "5eab5e81addee9f3576d456d205208314b5146a5";
      };
      meta = {
        description = "Android + Google APIs";
        url = http://developer.android.com/;
      };
    };

  google_apis_12 = buildGoogleApis {
    name = "google_apis-12";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-12_r01.zip;
        sha1 = "e9999f4fa978812174dfeceec0721c793a636e5d";
      };
      meta = {
        description = "Android + Google APIs";
        url = http://developer.android.com/;
      };
    };

  google_apis_13 = buildGoogleApis {
    name = "google_apis-13";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-13_r01.zip;
        sha1 = "3b153edd211c27dc736c893c658418a4f9041417";
      };
      meta = {
        description = "Android + Google APIs";
        url = http://developer.android.com/;
      };
    };

  google_apis_14 = buildGoogleApis {
    name = "google_apis-14";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-14_r02.zip;
        sha1 = "f8eb4d96ad0492b4c0db2d7e4f1a1a3836664d39";
      };
      meta = {
        description = "Android + Google APIs";

      };
    };

  google_apis_15 = buildGoogleApis {
    name = "google_apis-15";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-15_r03.zip;
        sha1 = "d0d2bf26805eb271693570a1aaec33e7dc3f45e9";
      };
      meta = {
        description = "Android + Google APIs";

      };
    };

  google_apis_16 = buildGoogleApis {
    name = "google_apis-16";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-16_r04.zip;
        sha1 = "ee6acf1b01020bfa8a8e24725dbc4478bee5e792";
      };
      meta = {
        description = "Android + Google APIs";

      };
    };

  google_apis_17 = buildGoogleApis {
    name = "google_apis-17";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-17_r04.zip;
        sha1 = "a076be0677f38df8ca5536b44dfb411a0c808c4f";
      };
      meta = {
        description = "Android + Google APIs";

      };
    };

  google_apis_18 = buildGoogleApis {
    name = "google_apis-18";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-18_r04.zip;
        sha1 = "6109603409debdd40854d4d4a92eaf8481462c8b";
      };
      meta = {
        description = "Android + Google APIs";

      };
    };

  google_apis_19 = buildGoogleApis {
    name = "google_apis-19";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-19_r20.zip;
        sha1 = "5b933abe830b2f25b4c0f171d45e9e0651e56311";
      };
      meta = {
        description = "Android + Google APIs";

      };
    };

  google_apis_21 = buildGoogleApis {
    name = "google_apis-21";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-21_r01.zip;
        sha1 = "66a754efb24e9bb07cc51648426443c7586c9d4a";
      };
      meta = {
        description = "Android + Google APIs";

      };
    };

  google_apis_22 = buildGoogleApis {
    name = "google_apis-22";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-22_r01.zip;
        sha1 = "5def0f42160cba8acff51b9c0c7e8be313de84f5";
      };
      meta = {
        description = "Android + Google APIs";

      };
    };

  google_apis_23 = buildGoogleApis {
    name = "google_apis-23";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-23_r01.zip;
        sha1 = "04c5cc1a7c88967250ebba9561d81e24104167db";
      };
      meta = {
        description = "Android + Google APIs";

      };
    };

  google_apis_24 = buildGoogleApis {
    name = "google_apis-24";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-24_r1.zip;
        sha1 = "31361c2868f27343ee917fbd259c1463821b6145";
      };
      meta = {
        description = "Android + Google APIs";

      };
    };

  google_apis_25 = buildGoogleApis {
    name = "google_apis-25";
      src = fetchurl {
        url = https://dl.google.com/android/repository/google_apis-25_r1.zip;
        sha1 = "550e83eea9513ab11c44919ac6da54b36084a9f3";
      };
      meta = {
        description = "Android + Google APIs";

      };
    };

  android_support_extra = buildGoogleApis {
    name = "android_support_extra";
    src = fetchurl {
      url = https://dl.google.com/android/repository/support_r23.2.1.zip;
      sha1 = "41121bbc412c2fce0be170d589d20cfa3e78e857";
    };
    meta = {
      description = "Android Support Library";
      url = http://developer.android.com/;
    };
  };


  google_play_services = buildGoogleApis {
    name = "google_play_services";
    src = fetchurl {
      url = https://dl.google.com/android/repository/google_play_services_v11_3_rc05.zip;
      sha1 = "6b072d5b96fb8726405d363ccdbb4d26bec0b54f";
    };
    meta = {
      description = "Google Play services client library and sample code";
      url = http://developer.android.com/;
    };
  };

}
