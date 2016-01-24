{ stdenv, requireFile, p7zip, jre, libusb1, platformTools, gtk2, glib, libXtst }:

assert stdenv.system == "i686-linux";

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

stdenv.mkDerivation rec {
  name = "flashtool-0.9.14.0";

  src = requireFile {
    url = "http://dfiles.eu/files/n8c1c3pgc";
    name = "flashtool-0.9.14.0-linux.tar.7z";
    sha256 = "0mfjdjj7clz2dhkg7lzy1m8hk8ngla7zgcryf51aki1gnpbb2zc1";
  };

  buildInputs = [ p7zip jre ];

  unpackPhase = ''
    7z e ${src}
    tar xf ${name}-linux.tar
    sourceRoot=FlashTool
  '';

  buildPhase = ''
    ln -s ${platformTools}/platform-tools/adb x10flasher_lib/adb.linux
    ln -s ${platformTools}/platform-tools/fastboot x10flasher_lib/fastboot.linux
    ln -s ${libusb1.out}/lib/libusb-1.0.so.0 ./x10flasher_lib/linux/lib32/libusbx-1.0.so

    chmod +x x10flasher_lib/unyaffs.linux.x86 x10flasher_lib/bin2elf x10flasher_lib/bin2sin
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" x10flasher_lib/unyaffs.linux.x86
    ln -sf unyaffs.linux.x86 x10flasher_lib/unyaffs.linux

    ln -s swt32.jar x10flasher_lib/swtlin/swt.jar

    sed -i \
      -e 's|$(uname -m)|i686|' \
      -e 's|export JAVA_HOME=.*|export JAVA_HOME=${jre}|' \
      -e 's|export LD_LIBRARY_PATH=.*|export LD_LIBRARY_PATH=${libXtst}/lib:${glib}/lib:${gtk2}/lib:./x10flasher_lib/linux/lib32|' \
      FlashTool FlashToolConsole
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
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
