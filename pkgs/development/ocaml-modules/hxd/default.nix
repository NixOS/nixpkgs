{ lib, buildDunePackage, fetchurl
, dune-configurator, cmdliner, angstrom
, rresult, stdlib-shims, fmt, fpath
}:

buildDunePackage rec {
  pname = "hxd";
  version = "0.2.0";

  useDune2 = true;

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/dinosaure/hxd/releases/download/v${version}/hxd-v${version}.tbz";
    sha256 = "1lyfrq058cc9x0c0hzsf3hv3ys0h8mxkwin9lldidlnj10izqf1l";
  };

  nativeBuildInputs = [
    dune-configurator
  ];

  buildInputs = [
    cmdliner
    angstrom
    rresult
    fmt
    fpath
  ];

  propagatedBuildInputs = [
    stdlib-shims
  ];

  meta = with lib; {
    description = "Hexdump in OCaml";
    homepage = "https://github.com/dinosaure/hxd";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
