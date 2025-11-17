{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "wtf8";
  version = "1.0.2";

  useDune2 = true;

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "09ygcxxd5warkdzz17rgpidrd0pg14cy2svvnvy1hna080lzg7vp";
  };

  meta = with lib; {
    homepage = "https://github.com/flowtype/ocaml-wtf8";
    description = "WTF-8 is a superset of UTF-8 that allows unpaired surrogates";
    license = licenses.mit;
    maintainers = [ maintainers.eqyiel ];
  };
}
