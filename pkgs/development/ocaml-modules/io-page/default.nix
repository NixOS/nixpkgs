{ stdenv, fetchurl, buildDunePackage, configurator, cstruct, bigarray-compat, ounit }:

buildDunePackage rec {
  pname = "io-page";
  version = "2.3.0";

  minimumOCamlVersion = "4.02.3";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "1hx27pwf419hrhwaw9cphbnl8akz8yy73hqj49l15g2k7shah1cn";
  };

  propagatedBuildInputs = [ cstruct bigarray-compat ];
  checkInputs = [ ounit ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/io-page";
    license = stdenv.lib.licenses.isc;
    description = "IO memory page library for Mirage backends";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
