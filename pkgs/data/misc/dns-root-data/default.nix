{ stdenv, lib, fetchurl }:

let

  rootHints = fetchurl {
    # Original source https://www.internic.net/domain/named.root
    # occasionally suffers from pointless hash changes,
    # and having stable sources for older versions has advantages, too.
    urls = map (prefix: prefix + "d9c96ae96f066a85d7/etc/root.hints") [
      "https://gitlab.nic.cz/knot/knot-resolver/raw/"
      "https://raw.githubusercontent.com/CZ-NIC/knot-resolver/"
    ];
    hash = "sha256-4lG/uPnNHBNIZ/XIeDM1w3iukrpeW0JIjTnGSwkJ8U4=";
  };

  rootKey = ./root.key;
  rootDs = ./root.ds;

in

stdenv.mkDerivation {
  pname = "dns-root-data";
  version = "2024-06-20";

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
