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
  version = "2025.310.174671";

  src = fetchurl {
    url = "https://binaries.twingate.com/client/linux/DEB/x86_64/${version}/twingate-amd64.deb";
    hash = "sha256-ZzOsXpjLBR447Kvo2kwy9y8TRm8Yp3EMlVx6vQU72jQ=";
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
  '';

  passthru.tests = { inherit (nixosTests) twingate; };

  meta = with lib; {
    description = "Twingate Client";
    homepage = "https://twingate.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ tonyshkurenko ];
    platforms = [ "x86_64-linux" ];
  };
}
