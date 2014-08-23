
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
      url = https://dl-ssl.google.com/android/repository/android-1.1_r1-linux.zip;
      sha1 = "c054d25c9b4c6251fa49c2f9c54336998679d3fe";
    };
    meta = {
      description = "Android SDK Platform 1.1_r1";
      url = http://developer.android.com/sdk/android-1.1.html;
    };
  };
    
  platform_3 = buildPlatform {
    name = "android-platform-1.5";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-1.5_r04-linux.zip;
      sha1 = "5c134b7df5f4b8bd5b61ba93bdaebada8fa3468c";
    };
    meta = {
      description = "Android SDK Platform 1.5_r3";
      url = http://developer.android.com/sdk/android-1.5.html;
    };
  };
    
  platform_4 = buildPlatform {
    name = "android-platform-1.6";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-1.6_r03-linux.zip;
      sha1 = "483ed088e45bbdf3444baaf9250c8b02e5383cb0";
    };
    meta = {
      description = "Android SDK Platform 1.6_r2";
      url = http://developer.android.com/sdk/android-1.6.html;
    };
  };
    
  platform_5 = buildPlatform {
    name = "android-platform-2.0";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-2.0_r01-linux.zip;
      sha1 = "be9be6a99ca32875c96ec7f91160ca9fce7e3c7d";
    };
    meta = {
      description = "Android SDK Platform 2.0, revision 1";
      url = http://developer.android.com/sdk/android-2.0.html;
    };
  };
    
  platform_6 = buildPlatform {
    name = "android-platform-2.0.1";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-2.0.1_r01-linux.zip;
      sha1 = "ce2c971dce352aa28af06bda92a070116aa5ae1a";
    };
    meta = {
      description = "Android SDK Platform 2.0.1_r1";
      url = http://developer.android.com/sdk/android-2.0.1.html;
    };
  };
    
  platform_7 = buildPlatform {
    name = "android-platform-2.1";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-2.1_r03-linux.zip;
      sha1 = "5ce51b023ac19f8738500b1007a1da5de2349a1e";
    };
    meta = {
      description = "Android SDK Platform 2.1_r3";
      url = http://developer.android.com/sdk/;
    };
  };
    
  platform_8 = buildPlatform {
    name = "android-platform-2.2";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-2.2_r03-linux.zip;
      sha1 = "231262c63eefdff8fd0386e9ccfefeb27a8f9202";
    };
    meta = {
      description = "Android SDK Platform 2.2_r3";
      url = http://developer.android.com/sdk/;
    };
  };
    
  platform_9 = buildPlatform {
    name = "android-platform-2.3.1";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-2.3.1_r02-linux.zip;
      sha1 = "209f8a7a8b2cb093fce858b8b55fed3ba5206773";
    };
    meta = {
      description = "Android SDK Platform 2.3.1_r2";
      url = http://developer.android.com/sdk/;
    };
  };
    
  platform_10 = buildPlatform {
    name = "android-platform-2.3.3";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-2.3.3_r02-linux.zip;
      sha1 = "887e37783ec32f541ea33c2c649dda648e8e6fb3";
    };
    meta = {
      description = "Android SDK Platform 2.3.3._r2";
      url = http://developer.android.com/sdk/;
    };
  };
    
  platform_11 = buildPlatform {
    name = "android-platform-3.0";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-3.0_r02-linux.zip;
      sha1 = "2c7d4bd13f276e76f6bbd87315fe27aba351dd37";
    };
    meta = {
      description = "Android SDK Platform 3.0, revision 2";
      url = http://developer.android.com/sdk/;
    };
  };
    
  platform_12 = buildPlatform {
    name = "android-platform-3.1";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-3.1_r03-linux.zip;
      sha1 = "4a50a6679cd95bb68bb5fc032e754cd7c5e2b1bf";
    };
    meta = {
      description = "Android SDK Platform 3.1, revision 3";
      url = http://developer.android.com/sdk/;
    };
  };
    
  platform_13 = buildPlatform {
    name = "android-platform-3.2";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-3.2_r01-linux.zip;
      sha1 = "6189a500a8c44ae73a439604363de93591163cd9";
    };
    meta = {
      description = "Android SDK Platform 3.2, revision 1";
      url = http://developer.android.com/sdk/;
    };
  };
    
  platform_14 = buildPlatform {
    name = "android-platform-4.0";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-14_r03.zip;
      sha1 = "41ba83b51e886461628c41b1b4d47762e0688ed5";
    };
    meta = {
      description = "Android SDK Platform 4.0";
      
    };
  };
    
  platform_15 = buildPlatform {
    name = "android-platform-4.0.3";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-15_r03.zip;
      sha1 = "23da24610a8da51054c5391001c51ce43a778b97";
    };
    meta = {
      description = "Android SDK Platform 4.0.3";
      
    };
  };
    
  platform_16 = buildPlatform {
    name = "android-platform-4.1.2";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-16_r04.zip;
      sha1 = "90b9157b8b45f966be97e11a22fba4591b96c2ee";
    };
    meta = {
      description = "Android SDK Platform 4.1.2";
      
    };
  };
    
  platform_17 = buildPlatform {
    name = "android-platform-4.2.2";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-17_r02.zip;
      sha1 = "c442c32c1b702173ab0929a74486e4f86fe528ec";
    };
    meta = {
      description = "Android SDK Platform 4.2.2";
      
    };
  };
    
  platform_18 = buildPlatform {
    name = "android-platform-4.3";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-18_r02.zip;
      sha1 = "62a9438d4cf6692f4d6510c27a380be195db9534";
    };
    meta = {
      description = "Android SDK Platform 4.3";
      
    };
  };
    
  platform_19 = buildPlatform {
    name = "android-platform-4.4";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/android-19_r01.zip;
      sha1 = "96281811998272dce46e8285d15fce444a3d5a96";
    };
    meta = {
      description = "Android SDK Platform 4.4";
      
    };
  };
    
}
  