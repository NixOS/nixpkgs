{ stdenv, requireFile, p7zip, jre, libusb1, androidsdk, gtk2, glib, libXtst }:

# TODO:
#
#   The FlashTool and FlashToolConsole scripts are messy and should probably we
#   replaced entirely. All these scripts do is try to guess the environment in
#   which to run the Java binary (and they guess wrong on NixOS).
#
#   The release contains a freaky mixture of 32 and 64 bit binaries.
#   Personally, I run these things (as 'root') in 32 bit Linux by way of:
#
#      setarch i686 ./FlashTool
#
#   It should be possible to run them in 64 bit mode, too.
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
    for n in x10flasher_lib/adb.linux.*; do
      ln -sfv ${androidsdk}/bin/adb $n
    done
    for n in x10flasher_lib/fastboot.linux.*; do
      ln -sfv ${androidsdk}/bin/fastboot $n
    done
    for n in "x10flasher_lib/linux/lib"*"/"*"/libus"*".so"* ; do
      ln -sfv ${libusb1}/lib/libusb-1.0.so.0 $n
    done
    sed -i \
      -e 's|ln -sf libusbx-1.0.so.0.1.0|ln -sf ${libusb1}/lib/libusb-1.0.so.0|' \
      -e 's|export JAVA_HOME=.*|export JAVA_HOME=${jre}|' \
      -e 's|export LD_LIBRARY_PATH=.*|export LD_LIBRARY_PATH=${libXtst}/lib:${glib}/lib:${gtk2}/lib:./x10flasher_lib/linux/lib32|' \
      FlashTool FlashToolConsole
    chmod +x x10flasher_lib/unyaffs.linux.x86
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" x10flasher_lib/unyaffs.linux.x86
    ln -sf unyaffs.linux.x86 x10flasher_lib/unyaffs.linux.x64
  '';

  installPhase = ''
    mkdir -p $out
    mv * $out/
  '';

  meta = {
    homepage = "http://www.flashtool.net/";
    description = "S1 flashing software for Sony phones from X10 to Xperia Z Ultra";

    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = stdenv.lib.platforms.none;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
