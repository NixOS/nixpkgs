{ lib, buildDunePackage, fetchurl, ctypes, integers, result }:

buildDunePackage rec {
  pname = "unix-errno";
  version = "0.6.2";

  minimalOCamlVersion = "4.03.0"; # Specified to be 4.01.0, but it's actually 4.03

  src = fetchurl {
    url = "https://github.com/xapi-project/ocaml-unix-errno/releases/download/${version}/unix-errno-${version}.tbz";
    sha256 = "sha256-LWqbyGcxs6f/FcOPo3JYR3U+AL0JHeWCiGjuYhxxrWU=";
  };

  propagatedBuildInputs = [ ctypes integers result ];

  meta = with lib; {
    homepage = "https://github.com/xapi-project/ocaml-unix-errno"; # This is the repo used in the opam package
    description = "Unix errno types, maps, and support for OCaml";
    license = with licenses; [ isc lgpl21Only ]; # All the files indicate ISC, but there's an LGPL LICENSE file
    maintainers = with maintainers; [ dandellion ];
  };
}
