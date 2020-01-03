{fetchurl, optionalAttrs, system}:
# This file preloads all the archives which Arduino's build/build.xml
# would otherwise try to download itself. When updating this for a new
# version of Arduino, check build.xml for version numbers and new
# urls.
{
  "build/shared/reference-1.6.6-3.zip" = fetchurl {
    url = "https://downloads.arduino.cc/reference-1.6.6-3.zip";
    sha256 = "119nj1idz85l71fy6a6wwsx0mcd8y0ib1wy0l6j9kz88nkwvggy3";
  };
  "build/shared/Galileo_help_files-1.6.2.zip" = fetchurl {
    url = "https://downloads.arduino.cc/Galileo_help_files-1.6.2.zip";
    sha256 = "0qda0xml353sfhjmx9my4mlcyzbf531k40dcr1cnsa438xp2fw0w";
  };
  "build/shared/Edison_help_files-1.6.2.zip" = fetchurl {
    url = "https://downloads.arduino.cc/Edison_help_files-1.6.2.zip";
    sha256 = "1x25rivmh0zpa6lr8dafyxvim34wl3wnz3r9msfxg45hnbjqqwan";
  };
  "build/Ethernet-2.0.0.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Ethernet/archive/2.0.0.zip";
    sha256 = "0had46c1n1wx9fa7ki5dwidvchiy00pv7qj9msp6wgv199vm19m8";
  };
  "build/GSM-1.0.6.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/GSM/archive/1.0.6.zip";
    sha256 = "1kmikxr07cyzsnhhymvgj9m4dxi671ni120l33gfmmm6079qfwbk";
  };
  "build/Stepper-1.1.3.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Stepper/archive/1.1.3.zip";
    sha256 = "1kyv6bmhmbjh7z8x77v04aywd2s54nm80g0j07gay2sa3f6k1p4v";
  };
  "build/TFT-1.0.6.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/TFT/archive/1.0.6.zip";
    sha256 = "1d69xp3hrva58nrx0vy4skrr1h63649q1jnc2g55bpbaxjhf5j5w";
  };
  "build/WiFi-1.2.7.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/WiFi/archive/1.2.7.zip";
    sha256 = "1fmj2q2672hivp5jn05xhc875ii3w54nfja3b1yrp8s2fwinh7f6";
  };
  "build/Firmata-2.5.8.zip" = fetchurl {
    url = "https://github.com/firmata/arduino/archive/2.5.8.zip";
    sha256 = "0jmlqrnw5fksyqkjhcsl6j1q7c0clnvfr8yknanqqssc19pxp722";
  };
  "build/Bridge-1.7.0.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Bridge/archive/1.7.0.zip";
    sha256 = "1qpnb2mj77jm4qczk1ndgjc9j2kqxnyahxdvlp0120x6w2jcq8s8";
  };
  "build/Robot_Control-1.0.4.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Robot_Control/archive/1.0.4.zip";
    sha256 = "1pkabrghx3h8l60x571vwkbhfm02nhyn5x2vqz4vhx9cczr70zq7";
  };
  "build/Robot_Motor-1.0.3.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Robot_Motor/archive/1.0.3.zip";
    sha256 = "1pkvrimg77jrhdsz4l81y59hv50h6cl7hvhk9w8ac7ckg70lvxkw";
  };
  "build/RobotIRremote-2.0.0.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/RobotIRremote/archive/2.0.0.zip";
    sha256 = "0j5smap74j8p3wc6k0h73b1skj4gkr7r25jbjh1j1cg052dxri86";
  };
  "build/SpacebrewYun-1.0.1.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/SpacebrewYun/archive/1.0.1.zip";
    sha256 = "1zs6ymlzw66bglrm0x6d3cvr52q85c8rlm525x0wags111xx3s90";
  };
  "build/Temboo-1.2.1.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Temboo/archive/1.2.1.zip";
    sha256 = "1fyzfihsbcjpjasqbmbbfcall2zl48nzrp4xk9pslppal31mvl8x";
  };
  "build/Esplora-1.0.4.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Esplora/archive/1.0.4.zip";
    sha256 = "1dflfrg38f0312nxn6wkkgq1ql4hx3y9kplalix6mkqmzwrdvna4";
  };
  "build/Mouse-1.0.1.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Mouse/archive/1.0.1.zip";
    sha256 = "106jjqxzpf5lrs9akwvamqsblj5w2fb7vd0wafm9ihsikingiypr";
  };
  "build/Keyboard-1.0.2.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Keyboard/archive/1.0.2.zip";
    sha256 = "17yfj95r1i7fb87q4krmxmaq07b4x2xf8cjngrj5imj68wgjck53";
  };
  "build/SD-1.2.3.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/SD/archive/1.2.3.zip";
    sha256 = "0i5hb5hmrsrhfgxx8w7zzrfrkc751vs63vhxrj6qvwazhfcdpjw2";
  };
  "build/Servo-1.1.3.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Servo/archive/1.1.3.zip";
    sha256 = "1m019a75cdn1fg0cwlzbahmaqvg8sgzr6v1812rd7rjh8ismiah6";
  };
  "build/LiquidCrystal-1.0.7.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/LiquidCrystal/archive/1.0.7.zip";
    sha256 = "1wrxrqz3n4yrj9j1a2b7pdd7a1rlyi974ra7crv5amjng8817x9n";
  };
  "build/Adafruit_Circuit_Playground-1.8.1.zip" = fetchurl {
    url = "https://github.com/Adafruit/Adafruit_CircuitPlayground/archive/1.8.1.zip";
    sha256 = "1fl24px4c42f6shpb3livwsxgpj866yy285274qrj4m1zl07f18q";
  };
  "build/libastylej-2.05.1-4.zip" = fetchurl {
    url = "https://downloads.arduino.cc/libastylej-2.05.1-4.zip";
    sha256 = "0q307b85xba7izjh344kqby3qahg3f5zy18gg52sjk1lbkl9i39s";
  };
  "build/liblistSerials-1.4.2.zip" = fetchurl {
    url = "https://downloads.arduino.cc/liblistSerials/liblistSerials-1.4.2.zip";
    sha256 = "1p58b421k92rbgwfgbihy0d04mby7kfssghpmjb4gk9yix09za3m";
  };
  "build/shared/WiFi101-Updater-ArduinoIDE-Plugin-0.10.6.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/WiFi101-FirmwareUpdater-Plugin/releases/download/v0.10.6/WiFi101-Updater-ArduinoIDE-Plugin-0.10.6.zip";
    sha256 = "1k23xyr5dmr60y8hb9x24wrgd4mfgvrzky621p6fvawn5xbdq8a3";
  };
}
// optionalAttrs (system == "x86_64-linux") {
  "build/arduino-builder-linux64-1.4.4.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-linux64-1.4.4.tar.bz2";
    sha256 = "1m5b4rc9i235ra6isqdpjj9llddb5sldkhidb8c4i14mcqbdci1n";
  };
  "build/linux/avr-gcc-5.4.0-atmel3.6.1-arduino2-x86_64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-5.4.0-atmel3.6.1-arduino2-x86_64-pc-linux-gnu.tar.bz2";
    sha256 = "11ciwv9sw900wxb2fwm4i4ml4a85ylng0f595v0mf0xifc6jnhh5";
  };
  "build/linux/avrdude-6.3.0-arduino14-x86_64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino14-x86_64-pc-linux-gnu.tar.bz2";
    sha256 = "1z4b6pvn1823h8mg0iph88igmcnrk2y7skr3z44dqlwk0pryi1kr";
  };
  "build/linux/arduinoOTA-1.2.1-linux_amd64.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduinoOTA-1.2.1-linux_amd64.tar.bz2";
    sha256 = "1ya834p2cqjj8k1ad3yxcnzd4bcgrlqsqsli9brq1138ac6k30jv";
  };
  "build/avr-1.6.23.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/cores/avr-1.6.23.tar.bz2";
    sha256 = "1al449r8hcdck7f4y295g7q388qvbn6qhk2zqdvws9kg4mzqsq8q";
  };
}
// optionalAttrs (system == "i686-linux") {
  "build/arduino-builder-linux32-1.4.4.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-linux32-1.4.4.tar.bz2";
    sha256 = "0q3i1ba7vh14616d9ligizcz89yadr0skazxbrcq3mvvjqzbifw8";
  };
  "build/linux/avr-gcc-5.4.0-atmel3.6.1-arduino2-i686-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-5.4.0-atmel3.6.1-arduino2-i686-pc-linux-gnu.tar.bz2";
    sha256 = "13skspybzq80ndsi93s7v15900lf26n5243mbib77andyc27xy2i";
  };
  "build/linux/avrdude-6.3.0-arduino14-i686-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino14-i686-pc-linux-gnu.tar.bz2";
    sha256 = "1jklpk1sgrmbh1r25ynps4qcs5dbg6hd54fzjx4hcdf68cw0w42g";
  };
  "build/linux/arduinoOTA-1.2.1-linux_386.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduinoOTA-1.2.1-linux_386.tar.bz2";
    sha256 = "1m56ps58h0fs8rr4ifc45slmrdvalc63vhldy85isv28g15zdz9g";
  };
}
// optionalAttrs (system == "x86_64-darwin") {
  "build/arduino-builder-macosx-1.4.4.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-macosx-1.4.4.tar.bz2";
    sha256 = "1jp5kg32aiw062kcxlv660w38iaprifm8h3g2798izpwyfj0dmwg";
  };
  "build/macosx/avr-gcc-5.4.0-atmel3.6.1-arduino2-i386-apple-darwin11.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-5.4.0-atmel3.6.1-arduino2-i386-apple-darwin11.tar.bz2";
    sha256 = "1y2972b08ac59xwjqkyjmi5lf2pmzw88a6sdgci3x9rvahvh3idb";
  };
  "build/macosx/avrdude-6.3.0-arduino14-i386-apple-darwin11.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino14-i386-apple-darwin11.tar.bz2";
    sha256 = "0qsa3sb3f480fm2z75fq14cqddw5hq8w8q0c2a9cw8i7aa8kkl27";
  };
  "build/macosx/appbundler/appbundler-1.0ea-arduino4.jar.zip" = fetchurl {
    url = "https://downloads.arduino.cc/appbundler-1.0ea-arduino4.jar.zip";
    sha256 = "1vz0g98ancfqdf7yx5m3zrxmzb3fwp18zh5lkh2nyl5xlr9m368z";
  };
}
// optionalAttrs (system == "armv6l-linux") {
  "build/arduino-builder-linuxarm-1.4.4.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-linuxarm-1.4.4.tar.bz2";
    sha256 = "03bhlhdkg1jx0d3lh9194xgaqsbank9njhlnwy8braa7pw4p58gn";
  };
  "build/linux/avr-gcc-5.4.0-atmel3.6.1-arduino2-armhf-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-5.4.0-atmel3.6.1-arduino2-armhf-pc-linux-gnu.tar.bz2";
    sha256 = "17z9li387mx2acgad733h7l1jnnwv09ynw4nrwlqfahqqdfgjhb7";
  };
  "build/linux/avrdude-6.3.0-arduino14-armhf-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino14-armhf-pc-linux-gnu.tar.bz2";
    sha256 = "12amp8hqcj6gcdga7hfs22asgmgzafy8ny0rqhqs8n8d95sn586i";
  };
  "build/linux/arduinoOTA-1.2.1-linux_arm.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduinoOTA-1.2.1-linux_arm.tar.bz2";
    sha256 = "1q79w1d0h2lp3jcg58qrlh3k5lak7dbsnawrzm0jj8c6spfb6m5d";
  };
}
