{fetchurl, optionalAttrs, system}:

{
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
  "build/Firmata-2.5.3.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Firmata/archive/2.5.3.zip";
    sha256 = "1ims6bdmwv8lgcvd4ri4i39vqm1q5jbwirmki35bybqqb1sl171v";
  };
  "build/Bridge-1.6.3.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Bridge/archive/1.6.3.zip";
    sha256 = "1lha5wkzz63bgcn7bhx4rmgsh9ywa47lffycpyz6qjnl1pvm5mmj";
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
  "build/SpacebrewYun-1.0.1.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/SpacebrewYun/archive/1.0.1.zip";
    sha256 = "1zs6ymlzw66bglrm0x6d3cvr52q85c8rlm525x0wags111xx3s90";
  };
  "build/Temboo-1.1.7.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Temboo/archive/1.1.7.zip";
    sha256 = "0fq2q6qs0qp15njsl9dif8dkpxgb4cgg8jk3s5y0fcz9lb8m2j50";
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
  "build/liblistSerials-1.1.4.zip" = fetchurl {
    url = "http://downloads.arduino.cc/liblistSerials/liblistSerials-1.1.4.zip";
    sha256 = "1w0zs155hs5b87i5wj049hfj2jsnf9jk30qq93wz1mxab01261v0";
  };
  "build/shared/WiFi101-Updater-ArduinoIDE-Plugin-0.8.0.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/WiFi101-FirmwareUpdater-Plugin/releases/download/v0.8.0/WiFi101-Updater-ArduinoIDE-Plugin-0.8.0.zip";
    sha256 = "0fp4mb1qa3w02hrwd51wf261l8ywcl36mi9wipsrgx2y29pk759z";
  };
}
// optionalAttrs (system == "x86_64-linux") {
  "build/arduino-builder-linux64-1.3.21_r1.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/arduino-builder-linux64-1.3.21_r1.tar.bz2";
    sha256 = "1cqx5smzm4dhbj2ah191vbbxi0l7xj95c5gcdbgqm9283hrpfrn7";
  };
  "build/linux/avr-gcc-4.9.2-atmel3.5.3-arduino2-x86_64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avr-gcc-4.9.2-atmel3.5.3-arduino2-x86_64-pc-linux-gnu.tar.bz2";
    sha256 = "124icbjh28cax6pgg6bzrfdi27shsn9mjjshgrr93pczpg8sc0rr";
  };
  "build/linux/avrdude-6.3.0-arduino6-x86_64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avrdude-6.3.0-arduino6-x86_64-pc-linux-gnu.tar.bz2";
    sha256 = "08b6dbllnvzv1aqx0v037zks4r3vqcx6yxxv040wf431mmf8gd4p";
  };
}
// optionalAttrs (system == "i686-linux") {
  "build/arduino-builder-linux32-1.3.21_r1.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/arduino-builder-linux32-1.3.21_r1.tar.bz2";
    sha256 = "1prfwb5scprvd74gihd78ibsdy3806b0fsjhgyj9in4w1q8s3dxj";
  };
  "build/linux/avr-gcc-4.9.2-atmel3.5.3-arduino2-i686-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avr-gcc-4.9.2-atmel3.5.3-arduino2-i686-pc-linux-gnu.tar.bz2";
    sha256 = "0s7chsp1jyk477zvfaraf0yacvlzahkwqxpws4k0kjadghg9a27i";
  };
  "build/linux/avrdude-6.3.0-arduino6-i686-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avrdude-6.3.0-arduino6-i686-pc-linux-gnu.tar.bz2";
    sha256 = "1yyn016b5162j94nmqcznfabi5y2ly27z2whr77387bvjnqc8jsz";
  };
}
// optionalAttrs (system == "x86_64-darwin") {
  "build/arduino-builder-macosx-1.3.21_r1.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/arduino-builder-macosx-1.3.21_r1.tar.bz2";
    sha256 = "06y5j1z9jjnqa7v6nl9dflm1qqpf3ar1jc53zxgdgsrb9c473d8l";
  };
  "build/linux/avr-gcc-4.9.2-arduino5-i386-apple-darwin11.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avr-gcc-4.9.2-atmel3.5.3-arduino2-i386-apple-darwin11.tar.bz2";
    sha256 = "12r4a1q7mh1gbasy7lqn0p4acg699lglw7il9d5f5vwd32pmh4ii";
  };
  "build/linux/avrdude-6.3.0-arduino6-i386-apple-darwin11.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avrdude-6.3.0-arduino6-i386-apple-darwin11.tar.bz2";
    sha256 = "11703f0r82aq3mmkiy7vwa4jfjhs9826qpp724hbng9dx74kk86r";
  };
}
// optionalAttrs (system == "armv6l-linux") {
  "build/arduino-builder-arm-1.3.21_r1.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/arduino-builder-arm-1.3.21_r1.tar.bz2";
    sha256 = "1ik6r5n6g20x4pb0vbxbkqxgzj39f13n995ki9xgpsrq22x6g1n4";
  };
  "build/linux/avr-gcc-4.9.2-arduino5-armhf-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avr-gcc-4.9.2-atmel3.5.3-arduino2-armhf-pc-linux-gnu.tar.bz2";
    sha256 = "08b8z7ca0wcgzxmjz6q5ihjrm3i10frnrcqpvwjrlsxw37ah1wvp";
  };
  "build/linux/avrdude-6.3.0-arduino6-armhf-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "http://downloads.arduino.cc/tools/avrdude-6.3.0-arduino6-armhf-pc-linux-gnu.tar.bz2";
    sha256 = "1rybp4hgk0mm7dydr3rj7yx59jzi30s4kyadzkjv13nm4ds209i4";
  };
}
