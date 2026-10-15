{
  autoPatchelfHook,
  curl,
  dpkg,
  dbus,
  fetchurl,
  lib,
  libnl,
  udev,
  cryptsetup,
  stdenv,
  nixosTests,
}:

let
  version = "2026.160.6555";

  sources = {
    x86_64-linux = {
      url = "https://binaries.twingate.com/client/linux/DEB/x86_64/${version}/twingate-amd64.deb";
      hash = "sha256-Sk2pALZtcraNpca6wkDiPCvWgU0hYlSeiwwszfZeKeM=";
    };
    aarch64-linux = {
      url = "https://binaries.twingate.com/client/linux/DEB/aarch64/${version}/twingate-arm64.deb";
      hash = "sha256-rK6bSSdkCNWHpOpojHn+CtZejiy6jarCb34aumBbmbs=";
    };
  };
in
stdenv.mkDerivation {
  pname = "twingate";
  inherit version;

  src = fetchurl sources.${stdenv.hostPlatform.system};

  buildInputs = [
    dbus
    curl
    libnl
    udev
    cryptsetup
  ];

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  postPatch = ''
    while read file; do
      substituteInPlace "$file" \
        --replace "/usr/bin" "$out/bin" \
        --replace "/usr/sbin" "$out/bin"
    done < <(find etc usr/lib usr/share -type f)
  '';

  installPhase = ''
    mkdir $out
    mv etc $out/
    mv usr/bin $out/bin
    mv usr/sbin/* $out/bin
    mv usr/lib $out/lib
    mv usr/share $out/share
  '';

  passthru.tests = { inherit (nixosTests) twingate; };

  meta = {
    description = "Twingate Client";
    homepage = "https://twingate.com";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
