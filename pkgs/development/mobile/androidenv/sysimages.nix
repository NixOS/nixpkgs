
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
    
  sysimg_14 = buildSystemImage {
    name = "armeabi-v7a-14";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sysimg_armv7a-14_r02.zip;
      sha1 = "d8991b0c06b18d7d6ed4169d67460ee1add6661b";
    };
  };
    
  sysimg_15 = buildSystemImage {
    name = "armeabi-v7a-15";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sysimg_armv7a-15_r02.zip;
      sha1 = "1bf977d6cb4e0ad38dceac0c4863d1caa21f326e";
    };
  };
    
  sysimg_16 = buildSystemImage {
    name = "armeabi-v7a-16";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sysimg_armv7a-16_r03.zip;
      sha1 = "d1cddb23f17aad5821a089c403d4cddad2cf9ef7";
    };
  };
    
  sysimg_17 = buildSystemImage {
    name = "armeabi-v7a-17";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sysimg_armv7a-17_r02.zip;
      sha1 = "1c321cda1af793b84d47d1a8d15f85444d265e3c";
    };
  };
    
  sysimg_18 = buildSystemImage {
    name = "armeabi-v7a-18";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sysimg_armv7a-18_r01.zip;
      sha1 = "5a9b8ac5b57dd0e3278f47deb5ee58e1db6f1f9e";
    };
  };
    
}
  