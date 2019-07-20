{ stdenv, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "wtf8";
  version = "1.0.1";

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "1msg3vycd3k8qqj61sc23qks541cxpb97vrnrvrhjnqxsqnh6ygq";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/flowtype/ocaml-wtf8;
    description = "WTF-8 is a superset of UTF-8 that allows unpaired surrogates.";
    license = licenses.mit;
    maintainers = [ maintainers.eqyiel ];
  };
}
