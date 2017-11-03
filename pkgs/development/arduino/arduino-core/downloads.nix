{fetchurl, optionalAttrs, system}:

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
  "build/Firmata-2.5.6.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Firmata/archive/2.5.6.zip";
    sha256 = "117dd4pdlgv60gdlgm2ckjfq89i0dg1q8vszg6hxywdf701c1fk4";
  };
  "build/Bridge-1.6.3.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Bridge/archive/1.6.3.zip";
    sha256 = "1lha5wkzz63bgcn7bhx4rmgsh9ywa47lffycpyz6qjnl1pvm5mmj";
  };
  "build/Robot_Control-1.0.3.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Robot_Control/archive/1.0.3.zip";
    sha256 = "1pc3b8skbpx7j32jnxa67mfqhnsmfz3876pc9mdyzpsad4mmcn62";
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
  "build/Keyboard-1.0.1.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Keyboard/archive/1.0.1.zip";
    sha256 = "1spv73zhjbrb0vgpzjnh6wr3bddlbyzv78d21dbn8z2l0aqv2sac";
  };
  "build/SD-1.1.1.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/SD/archive/1.1.1.zip";
    sha256 = "0nackcf7yx5np1s24wnsrcjl8j0nlmqqir6316vqqkfayvb1247n";
  };
  "build/Servo-1.1.2.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/Servo/archive/1.1.2.zip";
    sha256 = "14k1883qrx425wnm0r8kszzq32yvvs3jwxf3g7ybp7v0ga0q47l7";
  };
  "build/Adafruit_CircuitPlayground-1.6.4.zip" = fetchurl {
    url = "https://github.com/Adafruit/Adafruit_CircuitPlayground/archive/1.6.4.zip";
    sha256 = "1ph7m0l1sfx9db56n2h6vi78pn3zyah813lfhqiqghncx34amrhj";
  };
  "build/libastylej-2.05.1-3.zip" = fetchurl {
    url = "https://downloads.arduino.cc/libastylej-2.05.1-3.zip";
    sha256 = "0a1xy2cdl0xls5r21vy5d2j1dapn1jsdw0vbimlwnzfx7r84mxa6";
  };
  "build/liblistSerials-1.4.0.zip" = fetchurl {
    url = "https://downloads.arduino.cc/liblistSerials/liblistSerials-1.4.0.zip";
    sha256 = "129mfbyx7snq3znzhkfbdjiifdr85cwk6wjn8l9ia0wynszs5zyv";
  };
  "build/shared/WiFi101-Updater-ArduinoIDE-Plugin-0.9.0.zip" = fetchurl {
    url = "https://github.com/arduino-libraries/WiFi101-FirmwareUpdater-Plugin/releases/download/v0.9.0/WiFi101-Updater-ArduinoIDE-Plugin-0.9.0.zip";
    sha256 = "1nkk87q2l3bs9y387hdxzgqllm0lqpmc5kdmr6my4hjz5lcpgbza";
  };
}
// optionalAttrs (system == "x86_64-linux") {
  "build/arduino-builder-linux64-1.3.25.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-linux64-1.3.25.tar.bz2";
    sha256 = "15y80p255w2rg028vc8dq4hpqsmf770qigv3hgf78npb4qrjnqqf";
  };
  "build/linux/avr-gcc-4.9.2-atmel3.5.4-arduino2-x86_64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-4.9.2-atmel3.5.4-arduino2-x86_64-pc-linux-gnu.tar.bz2";
    sha256 = "132qm8l6h50z4s9h0i5mfv6bp0iia0pp9kc3gd37hkajy4bh4j0r";
  };
  "build/linux/avrdude-6.3.0-arduino9-x86_64-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino9-x86_64-pc-linux-gnu.tar.bz2";
    sha256 = "0shz5ymnlsrbnaqcb13fwbd73hz9k45adw14gf1ywjgywa2cpk68";
  };
  "build/linux/arduinoOTA-1.1.1-linux_amd64.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduinoOTA-1.1.1-linux_amd64.tar.bz2";
    sha256 = "0xy25srvpz6d0yfnz8b17mkmary3k51lb1cvgw7n2zyxayjd0npb";
  };
}
// optionalAttrs (system == "i686-linux") {
  "build/arduino-builder-linux32-1.3.25.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-linux32-1.3.25.tar.bz2";
    sha256 = "0hjiqbf7xspdcr7lganqnl68qcmndc9pz06dghkrwzbzc5ki72qr";
  };
  "build/linux/avr-gcc-4.9.2-atmel3.5.4-arduino2-i686-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-4.9.2-atmel3.5.4-arduino2-i686-pc-linux-gnu.tar.bz2";
    sha256 = "1d81z5m4cklv29hgb5ywrmyq64ymlwmjx2plm1gzs1mcpg7d9ab3";
  };
  "build/linux/avrdude-6.3.0-arduino9-i686-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino9-i686-pc-linux-gnu.tar.bz2";
    sha256 = "12r1drjafxwzrvf1y1glxd46rv870mhz1ifn0g328ciwivas4da2";
  };
  "build/linux/arduinoOTA-1.1.1-linux_386.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduinoOTA-1.1.1-linux_386.tar.bz2";
    sha256 = "1vvilbbbvv68svxzyhjspacbavcqakph5glhnz7c0mxkspqixjbs";
  };
}
// optionalAttrs (system == "x86_64-darwin") {
  "build/arduino-builder-macosx-1.3.25.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-macosx-1.3.25.tar.bz2";
    sha256 = "0inkxjzdplb8b17j7lyam6v9gca25rxmsinrkgqnx3xxgkaxz2k0";
  };
  "build/macosx/avr-gcc-4.9.2-atmel3.5.4-arduino2-i386-apple-darwin11.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-4.9.2-atmel3.5.4-arduino2-i386-apple-darwin11.tar.bz2";
    sha256 = "0c27i3y4f5biinxjdpp43wbj00lz7dvl08pnqr7hpkzaalsyvcv7";
  };
  "build/macosx/avrdude-6.3.0-arduino9-i386-apple-darwin11.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino9-i386-apple-darwin11.tar.bz2";
    sha256 = "0rc4x8mcsva4v6j7ssfj8rdyg14l2pd9ivgdm39m5wnz8b06p85z11703f0r82aq3mmkiy7vwa4jfjhs9826qpp724hbng9dx74kk86r";
  };
  "build/macosx/appbundler/appbundler-1.0ea-arduino4.jar.zip" = fetchurl {
    url = "https://downloads.arduino.cc/appbundler-1.0ea-arduino4.jar.zip";
    sha256 = "1vz0g98ancfqdf7yx5m3zrxmzb3fwp18zh5lkh2nyl5xlr9m368z";
  };
}
// optionalAttrs (system == "armv6l-linux") {
  "build/arduino-builder-linuxarm-1.3.25.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduino-builder-linuxarm-1.3.25.tar.bz2";
    sha256 = "1jvlihpcbdv1sgq1wjdwp7dhznk7nd88zin6yj40kr80gcd2ykry";
  };
  "build/linux/avr-gcc-4.9.2-atmel3.5.4-arduino2-armhf-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avr-gcc-4.9.2-atmel3.5.4-arduino2-armhf-pc-linux-gnu.tar.bz2";
    sha256 = "033jb1vmspcxsv0w9pk73xv195xnbnmckjsiccgqs8xx36g00dpf";
  };
  "build/linux/avrdude-6.3.0-arduino9-armhf-pc-linux-gnu.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/avrdude-6.3.0-arduino9-armhf-pc-linux-gnu.tar.bz2";
    sha256 = "1kp1xry97385zbrs94j285h1gqlzyyhkchh26z7zq6c0wi5879i5";
  };
  "build/linux/arduinoOTA-1.1.1-linux_arm.tar.bz2" = fetchurl {
    url = "https://downloads.arduino.cc/tools/arduinoOTA-1.1.1-linux_arm.tar.bz2";
    sha256 = "0k1pib8lmvk6c0y3m038fj3mc18ax1hy3kbvgd5nygrxvy1hv274";
  };
}
