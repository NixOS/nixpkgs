{ lib, buildDunePackage, fetchurl
, alcotest
, astring, fmt
}:

buildDunePackage rec {
  pname = "domain-name";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/hannesm/domain-name/releases/download/v${version}/domain-name-v${version}.tbz";
    sha256 = "12kc9p2a2fi1ipc2hyhbzivxpph3npglxwdgvhd6v20rqqdyvnad";
  };

  minimumOCamlVersion = "4.03";

  buildInputs = [ alcotest ];

  propagatedBuildInputs = [ astring fmt ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/hannesm/domain-name";
    description = "RFC 1035 Internet domain names";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
