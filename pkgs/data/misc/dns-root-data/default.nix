{ stdenv, lib, fetchurl }:

let

  rootHints = fetchurl {
    # Original source https://www.internic.net/domain/named.root
    # occasionally suffers from pointless hash changes,
    # and having stable sources for older versions has advantages, too.
    urls = map (prefix: prefix + "cc5e14a264912/etc/root.hints") [
      "https://gitlab.nic.cz/knot/knot-resolver/raw/"
      "https://raw.githubusercontent.com/CZ-NIC/knot-resolver/"
    ];
    sha256 = "0vdrff4l8s8grif52dnh091s8qydhh88k25zqd9rj66sf1qwcwxl";
  };

  rootKey = ./root.key;
  rootDs = ./root.ds;

in

stdenv.mkDerivation {
  pname = "dns-root-data";
  version = "2019-01-11";

  buildCommand = ''
    mkdir $out
    cp ${rootHints} $out/root.hints
    cp ${rootKey} $out/root.key
    cp ${rootDs} $out/root.ds
  '';

  meta = with lib; {
    description = "DNS root data including root zone and DNSSEC key";
    maintainers = with maintainers; [ fpletz vcunat ];
    license = licenses.gpl3Plus;
  };
}
