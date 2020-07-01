{ lib, buildDunePackage, fetchurl
, ipaddr, macaddr, cmdliner
}:

buildDunePackage rec {
  pname = "tuntap";
  version = "2.0.0";

  minimumOCamlVersion = "4.04.2";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-tuntap/releases/download/v${version}/tuntap-v${version}.tbz";
    sha256 = "12wmls28h3jzikwyfw08d5f7ycsc9njwzbhd3qk2l8jnf5rakfsa";
  };

  propagatedBuildInputs = [ ipaddr macaddr cmdliner ];

  # tests manipulate network devices and use network
  # also depend on LWT 5
  doCheck = false;

  meta = {
    description = "Bindings to the UNIX tuntap facility";
    license = lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-tuntap";
  };
}
