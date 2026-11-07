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
  version = "2026.239.6882";

  sources = {
    x86_64-linux = {
      url = "https://binaries.twingate.com/client/linux/DEB/x86_64/${version}/twingate-amd64.deb";
      hash = "sha256-BLPXDW21LeidOAbwuTd+LrZo/hF3Zp6F56F015CXPm4=";
    };
    aarch64-linux = {
      url = "https://binaries.twingate.com/client/linux/DEB/aarch64/${version}/twingate-arm64.deb";
      hash = "sha256-EdCxpsTw1H2MS6tk++xKs66m/fXzP2wNGcv6PP/9G8I=";
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
    runHook preInstall

    mkdir $out
    mv etc $out/
    mv usr/bin $out/bin
    mv usr/sbin/* $out/bin
    mv usr/lib $out/lib
    mv usr/share $out/share

    # 2026.188 renamed the CLI to `twingate-classic`
    ln -s twingate-classic $out/bin/twingate

    runHook postInstall
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
