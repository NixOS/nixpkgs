{
  lib,
  easy-format,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "dum";
  version = "1.0.3";

  src = fetchurl {
    url = "https://github.com/mjambon/dum/releases/download/${version}/dum-${version}.tbz";
    hash = "sha256-ZFojUD/IoxVTDfGyh2wveFsSz4D19pKkHrNuU+LFJlE=";
  };

  postPatch = ''
    substituteInPlace "dum.ml" \
    --replace "Lazy.lazy_is_val" "Lazy.is_val" \
    --replace "Obj.final_tag" "Obj.custom_tag"
  '';

  propagatedBuildInputs = [ easy-format ];

  meta = with lib; {
    homepage = "https://github.com/mjambon/dum";
    description = "Inspect the runtime representation of arbitrary OCaml values";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.alexfmpe ];
  };
}
