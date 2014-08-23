
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
        url = https://dl-ssl.google.com/android/repository/google_apis-3-r03.zip;
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
        url = https://dl-ssl.google.com/android/repository/google_apis-4_r02.zip;
        sha1 = "9b6e86d8568558de4d606a7debc4f6049608dbd0";
      };
      meta = {
        description = "Android + Google APIs, revision 2";
        url = http://developer.android.com/;
      };
    };
    
  google_apis_5 = buildGoogleApis {
    name = "google_apis-5";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-5_r01.zip;
        sha1 = "46eaeb56b645ee7ffa24ede8fa17f3df70db0503";
      };
      meta = {
        description = "Android + Google APIs, revision 1";
        url = http://developer.android.com/;
      };
    };
    
  google_apis_6 = buildGoogleApis {
    name = "google_apis-6";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-6_r01.zip;
        sha1 = "5ff545d96e031e09580a6cf55713015c7d4936b2";
      };
      meta = {
        description = "Android + Google APIs, revision 1";
        url = http://developer.android.com/;
      };
    };
    
  google_apis_7 = buildGoogleApis {
    name = "google_apis-7";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-7_r01.zip;
        sha1 = "2e7f91e0fe34fef7f58aeced973c6ae52361b5ac";
      };
      meta = {
        description = "Android + Google APIs, revision 1";
        url = http://developer.android.com/;
      };
    };
    
  google_apis_8 = buildGoogleApis {
    name = "google_apis-8";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-8_r02.zip;
        sha1 = "3079958e7ec87222cac1e6b27bc471b27bf2c352";
      };
      meta = {
        description = "Android + Google APIs, API 8, revision 2";
        url = http://developer.android.com/;
      };
    };
    
  google_apis_9 = buildGoogleApis {
    name = "google_apis-9";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-9_r02.zip;
        sha1 = "78664645a1e9accea4430814f8694291a7f1ea5d";
      };
      meta = {
        description = "Android + Google APIs, API 9, revision 2";
        url = http://developer.android.com/;
      };
    };
    
  google_apis_10 = buildGoogleApis {
    name = "google_apis-10";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-10_r02.zip;
        sha1 = "cc0711857c881fa7534f90cf8cc09b8fe985484d";
      };
      meta = {
        description = "Android + Google APIs, API 10, revision 2";
        url = http://developer.android.com/;
      };
    };
    
  google_apis_11 = buildGoogleApis {
    name = "google_apis-11";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-11_r01.zip;
        sha1 = "5eab5e81addee9f3576d456d205208314b5146a5";
      };
      meta = {
        description = "Android + Google APIs, API 11, revision 1";
        url = http://developer.android.com/;
      };
    };
    
  google_apis_12 = buildGoogleApis {
    name = "google_apis-12";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-12_r01.zip;
        sha1 = "e9999f4fa978812174dfeceec0721c793a636e5d";
      };
      meta = {
        description = "Android + Google APIs, API 12, revision 1";
        url = http://developer.android.com/;
      };
    };
    
  google_apis_13 = buildGoogleApis {
    name = "google_apis-13";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-13_r01.zip;
        sha1 = "3b153edd211c27dc736c893c658418a4f9041417";
      };
      meta = {
        description = "Android + Google APIs, API 13, revision 1";
        url = http://developer.android.com/;
      };
    };
    
  google_apis_14 = buildGoogleApis {
    name = "google_apis-14";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-14_r02.zip;
        sha1 = "f8eb4d96ad0492b4c0db2d7e4f1a1a3836664d39";
      };
      meta = {
        description = "Android + Google APIs";
        
      };
    };
    
  google_apis_15 = buildGoogleApis {
    name = "google_apis-15";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-15_r02.zip;
        sha1 = "6757c12788da0ea00c2ab58e54cb438b9f2bcf66";
      };
      meta = {
        description = "Android + Google APIs";
        
      };
    };
    
  google_apis_16 = buildGoogleApis {
    name = "google_apis-16";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-16_r03.zip;
        sha1 = "63467dd32f471e3e81e33e9772c22f33235aa3b3";
      };
      meta = {
        description = "Android + Google APIs";
        
      };
    };
    
  google_apis_17 = buildGoogleApis {
    name = "google_apis-17";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-17_r03.zip;
        sha1 = "8246f61d24f0408c8e7bc352a1e522b7e2b619ba";
      };
      meta = {
        description = "Android + Google APIs";
        
      };
    };
    
  google_apis_18 = buildGoogleApis {
    name = "google_apis-18";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-18_r03.zip;
        sha1 = "147bce09c1163edc17194f3db496ec1086fcf965";
      };
      meta = {
        description = "Android + Google APIs";
        
      };
    };
    
  google_apis_19 = buildGoogleApis {
    name = "google_apis-19";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/google_apis-19_r01.zip;
        sha1 = "6c530a8318446e4da1e3ab7d2abd154bc493bc5a";
      };
      meta = {
        description = "Android + Google APIs";
        
      };
    };
    
}
  