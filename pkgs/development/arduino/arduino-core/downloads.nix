{ fetchurl
, optionalAttrs
, system
}:
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
  "build/SpacebrewYun-1.0.2.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/SpacebrewYun/archive/1.0.2.zip";
    sha256 = "1d8smmsx12qhf2ldvmi93h48cvdyz4id5gd68cvf076wfyv6dks8";
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
  "build/SD-1.2.4.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/SD/archive/1.2.4.zip";
    sha256 = "123g9px9nqcrsx696wqwzjd5s4hr55nxgfz95b7ws3v007i1f3fz";
  };
  "build/Servo-1.1.6.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Servo/archive/1.1.6.zip";
    sha256 = "1z9k9lxzj5d3f8h9hy86f4k5wgfr2a9zcvjh76qmpvv6clcv3js3";
  };
  "build/LiquidCrystal-1.0.7.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/LiquidCrystal/archive/1.0.7.zip";
    sha256 = "1wrxrqz3n4yrj9j1a2b7pdd7a1rlyi974ra7crv5amjng8817x9n";
  };
  "build/Adafruit_Circuit_Playground-1.10.4.zip" = fetchurl {
    url = "https://github.com/adafruit/Adafruit_CircuitPlayground/archive/1.10.4.zip";
    sha256 = "194az5pxxzs0wg4ng7w0zqrdw93qdyv02y0q2yy57dr4kwfrm6nl";
  };
  "build/libastylej-2.05.1-5.zip" = fetchurl {
    url = "https://downloads.arduino.cc/libastylej-2.05.1-5.zip";
    sha256 = "11mlprwvqfq3nvmz6hdf1fcg02a7xi2a9qhffa1d8a4w15s2iwny";
  };
  "build/liblistSerials-1.4.2-2.zip" = fetchurl {
    url = "https://downloads.arduino.cc/liblistSerials/liblistSerials-1.4.2-2.zip";
    sha256 = "0sqzwp1lfjy452z3d4ma5c4blwsj7za72ymxf7crpq9dh9qd8f53";
  };
  "build/shared/WiFi101-Updater-ArduinoIDE-Plugin-0.10.10.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/WiFi101-FirmwareUpdater-Plugin/releases/download/v0.10.10/WiFi101-Updater-ArduinoIDE-Plugin-0.10.10.zip";
    sha256 = "0bs5qdglsfc2q5c48m6wdjpzhz4ya4askh1g8364dp6p7jmg6w0d";
  };
  "build/avr-1.8.2.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/cores/avr-1.8.2.tar.bz2";
    sha256 = "06zl8fwphknd0qdx87fcr1003gid1yqsazaj674mm9widqfd84v2";
  };
}

// optionalAttrs (system == "x86_64-linux") {
  "build/arduino-builder-linux64-1.5.2.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-linux64-1.5.2.tar.bz2";
    sha256 = "0wypr9a2cbv9r0ignsr13raw09i3vfc5zvkjxp2xwb7mv35y77z3";
  };
  "build/linux/avr-gcc-7.3.0-atmel3.6.1-arduino5-x86_64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-7.3.0-atmel3.6.1-arduino5-x86_64-pc-linux-gnu.tar.bz2";
    sha256 = "1yq6a811dabrkcgzfi3jsys41r19qsna46kglkjbcy0rza7yvzry";
  };
  "build/linux/avrdude-6.3.0-arduino17-x86_64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino17-x86_64-pc-linux-gnu.tar.bz2";
    sha256 = "0gfic26af9vlcpkw8v914psn05vmq1rsrlk1fi7vzapj1a9gpkdc";
  };
  "build/linux/arduinoOTA-1.3.0-linux_amd64.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduinoOTA-1.3.0-linux_amd64.tar.bz2";
    sha256 = "1ylz4pfa9np0nn0w9igmmm3sr8hz3na04n7cv8ia3hzz84jfwida";
  };
}

// optionalAttrs (system == "i686-linux") {
  "build/arduino-builder-linux32-1.5.2.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-linux32-1.5.2.tar.bz2";
    sha256 = "1slzw8fzxkqsp2izjisjd1rxxbqkrq6n72jc4frk5z2gdm6zfa0l";
  };
  "build/linux/avr-gcc-7.3.0-atmel3.6.1-arduino5-i686-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-7.3.0-atmel3.6.1-arduino5-i686-pc-linux-gnu.tar.bz2";
    sha256 = "078f3rbpdrghk63mbaq73bd5p6znimp14b1wdf6nh2gdswwjgw9g";
  };
  "build/linux/avrdude-6.3.0-arduino17-i686-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino17-i686-pc-linux-gnu.tar.bz2";
    sha256 = "0py0jvpim0frmv0dnvzfj122ni5hg1qwshgya4a0wc5rgp0wd32w";
  };
  "build/linux/arduinoOTA-1.3.0-linux_386.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduinoOTA-1.3.0-linux_386.tar.bz2";
    sha256 = "1cl79019ldsq0sc3fd4pm0vx2kqcklld7w03hdcj99y7zgb5jzry";
  };
}

// optionalAttrs (system == "x86_64-darwin") {
  "build/arduino-builder-macosx-1.5.2-signed.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-macosx-1.5.2-signed.tar.bz2";
    sha256 = "1pa795vwly1z9h1bp5qzbx2c2pq4n6p7ab5ivhmd3q89z0ywyqgz";
  };
  "build/macosx/avr-gcc-7.3.0-atmel3.6.1-arduino5-x86_64-apple-darwin14-signed.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-7.3.0-atmel3.6.1-arduino5-x86_64-apple-darwin14-signed.tar.bz2";
    sha256 = "0lcnp525glnc2chcynnz2nllm4q6ar4n9nrjqd1jbj4m706zbv67";
  };
  "build/macosx/avrdude-6.3.0-arduino17-x86_64-apple-darwin12-signed.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino17-x86_64-apple-darwin12-signed.tar.bz2";
    sha256 = "1m24dci8mjf70yrf033mp1834pbp870m8sns2jxs3iy2i4qviiki";
  };
  "build/linux/arduinoOTA-1.3.0-darwin_amd64-signed.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduinoOTA-1.3.0-darwin_amd64-signed.tar.bz2";
    sha256 = "12pwfnikq3z3ji5wgjhzx1mfyaha5cym7mr63r8kfl5a85fhk8nz";
  };
  "build/macosx/appbundler/appbundler-1.0ea-arduino5.jar.zip" = fetchurl {
    url = "https://downloads.arduino.cc/appbundler-1.0ea-arduino5.jar.zip";
    sha256 = "1ims951z7ajprqms7yd8ll83c79n7krhd9ljw30yn61f6jk46x82";
  };
}

// optionalAttrs (system == "aarch64-linux") {
  "build/arduino-builder-linuxaarch64-1.5.2.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-linuxaarch64-1.5.2.tar.bz2";
    sha256 = "14k7h7anjizbs2h04phw784slpfbi6hch9skvhy5ll805dmr24ci";
  };
  "build/linux/avr-gcc-7.3.0-atmel3.6.1-arduino5-aarch64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-7.3.0-atmel3.6.1-arduino5-aarch64-pc-linux-gnu.tar.bz2";
    sha256 = "040cspc41iv59fb2g9fzc6w5523dvqa1bavxni7s8w731ccp176x";
  };
  "build/linux/avrdude-6.3.0-arduino17-aarch64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino17-aarch64-pc-linux-gnu.tar.bz2";
    sha256 = "1z59dx2j2j4675awjzag9fswhvkn3hlz4ds5d2b7pzmca7vliybc";
  };
  "build/linux/arduinoOTA-1.3.0-linux_aarch64.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduinoOTA-1.3.0-linux_aarch64.tar.bz2";
    sha256 = "04s1is2w8xhvc7lg0lmyk0yjsnar2l2gdc6ig7lkgb7zgkrxhpl3";
  };
}

// optionalAttrs (builtins.match "armv[67]l-linux" system != null) {
  "build/arduino-builder-linuxarm-1.5.2.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-linuxarm-1.5.2.tar.bz2";
    sha256 = "1vs2s5px07jb2sdv83qxkf9lxmsy8j4dm7bn3vpw5dcjqd3qdyww";
  };
  "build/linux/avr-gcc-7.3.0-atmel3.6.1-arduino5-arm-linux-gnueabihf.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-7.3.0-atmel3.6.1-arduino5-arm-linux-gnueabihf.tar.bz2";
    sha256 = "0fcn0s0fdgbz3yma2gjv16s1idrzn6nhmypdw8awg0kb3i9xbb7l";
  };
  "build/linux/avrdude-6.3.0-arduino17-armhf-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino17-armhf-pc-linux-gnu.tar.bz2";
    sha256 = "1lah9wvwvliajrrf5jw5blkjhk1sxivz26gj5s86zah3v32ni3ia";
  };
  "build/linux/arduinoOTA-1.3.0-linux_arm.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduinoOTA-1.3.0-linux_arm.tar.bz2";
    sha256 = "0mm6spjlg0lhkfx5c9q27b6agjywnc1nf3mbl15yysmm15s5i20q";
  };
}
