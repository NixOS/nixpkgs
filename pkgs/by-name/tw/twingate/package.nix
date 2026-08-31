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

stdenv.mkDerivation rec {
  pname = "twingate";
  version = "2026.239.6882";

  src = fetchurl {
    url = "https://binaries.twingate.com/client/linux/DEB/x86_64/${version}/twingate-amd64.deb";
    hash = "sha256-BLPXDW21LeidOAbwuTd+LrZo/hF3Zp6F56F015CXPm4=";
  };

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
    # Expose the user-facing `twingate` command (no update-alternatives under Nix).
    ln -s twingate-classic $out/bin/twingate
  '';

  passthru.tests = { inherit (nixosTests) twingate; };

  meta = with lib; {
    description = "Twingate Client";
    homepage = "https://twingate.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
