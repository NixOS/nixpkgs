{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  openresolv,
  coreutils,
  systemd,
}:

let
  binPath = lib.makeBinPath [
    coreutils
    openresolv
    systemd
  ];

in
stdenv.mkDerivation {
  pname = "update-resolv-conf";
  version = "unstable-2017-06-21";

  src = fetchFromGitHub {
    owner = "alfredopalhares";
    repo = "openvpn-update-resolv-conf";
    rev = "43093c2f970bf84cd374e18ec05ac6d9cae444b8";
    hash = "sha256-W6FLt3UT7pdwe3c2VUhmkxEn7y/C4Rjet4aL/fQyxtE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm555 update-resolv-conf.sh $out/libexec/openvpn/update-resolv-conf
    install -Dm555 update-systemd-network.sh $out/libexec/openvpn/update-systemd-network

    for i in $out/libexec/openvpn/*; do
      wrapProgram $i --prefix PATH : ${binPath}
    done
  '';

  meta = {
    description = "Script to update your /etc/resolv.conf with DNS settings that come from the received push dhcp-options";
    homepage = "https://github.com/alfredopalhares/openvpn-update-resolv-conf/";
    maintainers = [ ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}
