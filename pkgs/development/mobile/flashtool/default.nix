{ stdenv, requireFile, p7zip, jre, libusb1, platformTools, gtk2, glib, libXtst, swt, makeWrapper, mono }:

assert stdenv.isLinux;

# TODO:
#
#   The FlashTool and FlashToolConsole scripts are messy and should probably we
#   replaced entirely. All these scripts do is try to guess the environment in
#   which to run the Java binary (and they guess wrong on NixOS).
#
#   The FlashTool scripts run 'chmod' on the binaries installed in the Nix
#   store. These commands fail, naturally, because the Nix story is (hopefully)
#   mounted read-only. This doesn't matter, though, because the build
#   instructions fix the executable bits already.

let

  CP = "$(ls ./x10flasher_lib/*.jar|xargs|tr ' ' ':')";
  SWT = "${swt}/jars/swt.jar";

  ARCH = if stdenv.system == "i686-linux" then "32" else "64";

in

stdenv.mkDerivation rec {
  name = "flashtool";
  version = "0.9.22.3";

  src = requireFile {
    url = "http://uploaded.net/file/fyc683jo";
    name = "${name}-${version}-linux.tar.7z";
    sha256 = "00sncfxi32y745cjf2zhaazs9p6zhpwqcrm91byja7d7pksf29ca";
  };

  buildInputs = [ p7zip jre swt makeWrapper mono ];

  unpackPhase = ''
    7z e ${src}
    tar xf ${name}-${version}-linux.tar
    sourceRoot=FlashTool
  '';

  buildPhase = ''
    rm x10flasher_lib/adb.linux.${ARCH}
    rm x10flasher_lib/fastboot.linux.${ARCH}
    ln -s ${platformTools}/platform-tools/adb x10flasher_lib/adb.linux.${ARCH}
    ln -s ${platformTools}/platform-tools/fastboot x10flasher_lib/fastboot.linux.${ARCH}

    ln -s ${libusb1.out}/lib/libusb-1.0.so.0 ./x10flasher_lib/linux/lib${ARCH}/libusbx-1.0.so

    rm FlashTool
    makeWrapper ${jre}/bin/java $out/FlashTool \
      --set JAVA_HOME "${jre}" \
      --set PATH "$out:$PATH" \
      --set LD_LIBRARY_PATH "${libXtst}/lib:${glib}/lib:${gtk2}/lib:${libusb1}/lib:${swt}/lib:x10flasher_lib/linux/lib${ARCH}:\$LD_LIBRARY_PATH" \
      --add-flags "-classpath $out/x10flasher.jar:${CP}:${SWT} -Xms128m -Xmx512m -Duser.country=US -Duser.language=en -Djsse.enableSNIExtension=false gui.Main"
    sed -i -e 's|Main.*$|Main|' $out/FlashTool
    sed -i -e 's|./x10flasher_lib|$out/x10flasher_lib|' $out/FlashTool
  '';

  installPhase = ''
    mkdir -p $out
    mv * $out/
  '';

  meta = {
    homepage = "http://www.flashtool.net/";
    description = "S1 flashing software for Sony phones from X10 to Xperia Z Ultra";
    license = stdenv.lib.licenses.unfreeRedistributableFirmware;
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = stdenv.lib.platforms.none;
  };
}
