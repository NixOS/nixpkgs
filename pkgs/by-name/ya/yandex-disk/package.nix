{ lib, stdenv, fetchurl, writeText, zlib, rpmextract, patchelf, which }:

let
  p = if stdenv.hostPlatform.is64bit then {
      arch = "x86_64";
      gcclib = "${lib.getLib stdenv.cc.cc}/lib64";
      sha256 = "sha256-HH/pLZmDr6m/B3e6MHafDGnNWR83oR2y1ijVMR/LOF0=";
      webarchive = "20220519080155";
    }
    else {
      arch = "i386";
      gcclib = "${lib.getLib stdenv.cc.cc}/lib";
      sha256 = "sha256-28dmdnJf+qh9r3F0quwlYXB/UqcOzcHzuzFq8vt2bf0=";
      webarchive = "20220519080430";
    };
in
stdenv.mkDerivation rec {

  pname = "yandex-disk";
  version = "0.1.6.1080";

  src = fetchurl {
    urls = [
      "https://repo.yandex.ru/yandex-disk/rpm/stable/${p.arch}/${pname}-${version}-1.fedora.${p.arch}.rpm"
      "https://web.archive.org/web/${p.webarchive}/https://repo.yandex.ru/yandex-disk/rpm/stable/${p.arch}/${pname}-${version}-1.fedora.${p.arch}.rpm"
    ];
    sha256 = p.sha256;
  };

  builder = writeText "builder.sh" ''
    . $stdenv/setup
    mkdir -pv $out/bin
    mkdir -pv $out/share
    mkdir -pv $out/etc

    mkdir -pv unpacked
    cd unpacked
    ${rpmextract}/bin/rpmextract $src

    mkdir -p $out/share/bash-completion/completions
    cp -r -t $out/bin usr/bin/*
    cp -r -t $out/share usr/share/*
    cp -r -t $out/share/bash-completion/completions etc/bash_completion.d/*

    sed -i 's@have@${which}/bin/which >/dev/null 2>\&1@' \
      $out/share/bash-completion/completions/yandex-disk-completion.bash

    ${patchelf}/bin/patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${zlib.out}/lib:${p.gcclib}" \
      $out/bin/yandex-disk
  '';

  meta = {
    homepage = "https://help.yandex.com/disk/cli-clients.xml";
    description = "Free cloud file storage service";
    maintainers = with lib.maintainers; [ smironov jagajaga ];
    platforms = ["i686-linux" "x86_64-linux"];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    longDescription = ''
      Yandex.Disk console client for Linux lets you manage files on Disk without
      using a window interface or programs that support WebDAV. The advantages
      of the console client compared to a WebDAV connection:
       * low system resource requirements;
       * faster file reading and writing speeds;
       * faster syncing with Disk's server;
       * no need to be constantly connected to work with files.
    '';
    mainProgram = "yandex-disk";
  };
}
