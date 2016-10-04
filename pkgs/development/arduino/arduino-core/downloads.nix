{fetchurl, optionalAttrs, system}:

{
  # Following 3 files are snapshots of files that were downloaded from http://download.arduino.cc/
  # Because original URLs update daily. https://github.com/binarin/arduino-indexes also contains script
  # for updating those snapshots.
  "package_index.json.gz" = fetchurl {
    url = "https://github.com/binarin/arduino-indexes/raw/snapshot-2016-07-18/package_index.json.gz";
    sha256 = "11y16864bca6h5n03xbk8cw3v9b4xwvjz5mkirkcxslkkf7cx5yg";
  };
  "package_index.json.sig" = fetchurl {
    url = "https://github.com/binarin/arduino-indexes/raw/snapshot-2016-07-18/package_index.json.sig";
    sha256 = "14ky3qb81mvqswaw9g5cpg5jcjqx6knfm75mzx1si7fbx576amls";
  };
  "library_index.json.gz" = fetchurl {
    url = "https://github.com/binarin/arduino-indexes/raw/snapshot-2016-07-18/library_index.json.gz";
    sha256 = "19md4yf4m4wh9vnc3aj0gm3jak1qa591z5yhg0x8lsxx5hr2v85z";
  };

  "build/shared/reference-1.6.6-3.zip" = fetchurl {
    url = "http://downloads.arduino.cc/reference-1.6.6-3.zip";
    sha256 = "119nj1idz85l71fy6a6wwsx0mcd8y0ib1wy0l6j9kz88nkwvggy3";
  };
  "build/shared/Galileo_help_files-1.6.2.zip" = fetchurl {
    url = "http://downloads.arduino.cc/Galileo_help_files-1.6.2.zip";
    sha256 = "0qda0xml353sfhjmx9my4mlcyzbf531k40dcr1cnsa438xp2fw0w";
  };
  "build/shared/Edison_help_files-1.6.2.zip" = fetchurl {
    url = "http://downloads.arduino.cc/Edison_help_files-1.6.2.zip";
    sha256 = "1x25rivmh0zpa6lr8dafyxvim34wl3wnz3r9msfxg45hnbjqqwan";
  };
  "build/Firmata-2.5.2.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Firmata/archive/2.5.2.zip";
    sha256 = "1r75bxvpr17kwhpks9nxxpm5d5qbw0qnhygakv06whan9s0dc5cz";
  };
  "build/Bridge-1.6.2.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Bridge/archive/1.6.2.zip";
    sha256 = "10v557bsxasq8ya09m9157nlk50cbkb0wlzrm54cznzmwc0gx49a";
  };
  "build/Robot_Control-1.0.2.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Robot_Control/archive/1.0.2.zip";
    sha256 = "1wdpz3ilnza3lfd5a628dryic46j72h4a89y8vp0qkbscvifcvdk";
  };
  "build/Robot_Motor-1.0.2.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Robot_Motor/archive/1.0.2.zip";
    sha256 = "0da21kfzy07kk2qnkprs3lj214fgkcjxlkk3hdp306jfv8ilmvy2";
  };
  "build/RobotIRremote-1.0.2.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/RobotIRremote/archive/1.0.2.zip";
    sha256 = "0wkya7dy4x0xyi7wn5aghmr1gj0d0wszd61pq18zgfdspz1gi6xn";
  };
  "build/SpacebrewYun-1.0.0.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/SpacebrewYun/archive/1.0.0.zip";
    sha256 = "1sklyp92m8i31rfb9b9iw0zvvab1zd7jdmg85fr908xn6k05qhmp";
  };
  "build/Temboo-1.1.5.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Temboo/archive/1.1.5.zip";
    sha256 = "1ak9b2wrd42n3ak7kcqwg28ianq01acsi5jv4cc031wr0kpq4507";
  };
  "build/Esplora-1.0.4.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Esplora/archive/1.0.4.zip";
    sha256 = "1dflfrg38f0312nxn6wkkgq1ql4hx3y9kplalix6mkqmzwrdvna4";
  };
  "build/Mouse-1.0.1.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Mouse/archive/1.0.1.zip";
    sha256 = "106jjqxzpf5lrs9akwvamqsblj5w2fb7vd0wafm9ihsikingiypr";
  };
  "build/Keyboard-1.0.1.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Keyboard/archive/1.0.1.zip";
    sha256 = "1spv73zhjbrb0vgpzjnh6wr3bddlbyzv78d21dbn8z2l0aqv2sac";
  };
  "build/libastylej-2.05.1-3.zip" = fetchurl {
    url = "http://downloads.arduino.cc/libastylej-2.05.1-3.zip";
    sha256 = "0a1xy2cdl0xls5r21vy5d2j1dapn1jsdw0vbimlwnzfx7r84mxa6";
  };
  "build/liblistSerials-1.1.0.zip" = fetchurl {
    url = "http://downloads.arduino.cc/liblistSerials/liblistSerials-1.1.0.zip";
    sha256 = "12n3y9y3gfi7i3x6llbwvi59jram02v8yyilv2kd38dm7wrqpw16";
  };
}
// optionalAttrs (system == "x86_64-linux") {
  "build/arduino-builder-linux64-1.3.18.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/arduino-builder-linux64-1.3.18.tar.bz2";
    sha256 = "0xbzcmvfa1h22dlvym8v4s68w4r1vdq8pj086sk1iwlkfiq0y4zq";
  };
  "build/linux/avr-gcc-4.8.1-arduino5-x86_64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avr-gcc-4.8.1-arduino5-x86_64-pc-linux-gnu.tar.bz2";
    sha256 = "1k793qsv1jdc0m4i9k40l2k7blnarfzy2k3clndl2yirfk0zqm4h";
  };
  "build/linux/avrdude-6.0.1-arduino5-x86_64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avrdude-6.0.1-arduino5-x86_64-pc-linux-gnu.tar.bz2";
    sha256 = "0xm4hfr4binny9f5affnmyrrq3lhrxr66s6ymplgfq9l72kwq9nq";
  };
}
// optionalAttrs (system == "i686-linux") {
  "build/arduino-builder-linux32-1.3.18.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/arduino-builder-linux32-1.3.18.tar.bz2";
    sha256 = "0b6ls31gaagni929v4isr8ivyviid37721ffhgw6mnb8vshcws2d";
  };
  "build/linux/avr-gcc-4.8.1-arduino5-i686-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avr-gcc-4.8.1-arduino5-i686-pc-linux-gnu.tar.bz2";
    sha256 = "07ql6apml1w5gy3ygd1wmj12yr8vg6p3pr8b1gd92wdk97svfj3n";
  };
  "build/linux/avrdude-6.0.1-arduino5-i686-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avrdude-6.0.1-arduino5-i686-pc-linux-gnu.tar.bz2";
    sha256 = "1vmzqvkg8z2xp3j5qypzyg26hgymy6vshs4vpax6mr5w4xlxccsr";
  };
}
// optionalAttrs (system == "x86_64-darwin") {
  "build/arduino-builder-macosx-1.3.18.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/arduino-builder-macosx-1.3.18.tar.bz2";
    sha256 = "01m21r2blh3rwzmjgjn65hivlbj95ddqkjq5xm1yb4b5h3i03mfj";
  };
  "build/linux/avr-gcc-4.8.1-arduino5-i386-apple-darwin11.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avr-gcc-4.8.1-arduino5-i386-apple-darwin11.tar.bz2";
    sha256 = "00d9i1vg1zngcd3f52c6d7j2iffb0qs97a1pnag0czbk1pq3w6qi";
  };
  "build/linux/avrdude-6.0.1-arduino5-i386-apple-darwin11.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avrdude-6.0.1-arduino5-i386-apple-darwin11.tar.bz2";
    sha256 = "1rf3dwb4534qzn0gdpbh3155knx07hbbakvv67456s2q18xqvbs1";
  };
}
// optionalAttrs (system == "armv6l-linux") {
  "build/arduino-builder-arm-1.3.18.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/arduino-builder-arm-1.3.18.tar.bz2";
    sha256 = "1v4vrmv24cajl7hxmyz5nh2y007kmwrcgl6180dlfwpc9526s4p1";
  };
  "build/linux/avr-gcc-4.8.1-arduino5-armhf-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avr-gcc-4.8.1-arduino5-armhf-pc-linux-gnu.tar.bz2";
    sha256 = "0jqmyamvvwiab6ag580h09zkxbpv6i5xn6ganj5b8ld6nwnwvzy8";
  };
  "build/linux/avrdude-6.0.1-arduino5-armhf-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avrdude-6.0.1-arduino5-armhf-pc-linux-gnu.tar.bz2";
    sha256 = "1d7n0jcc6670n803q57hzw8pvp9bmnca9c9fgw3fq5y1vd0i7si3";
  };
}
