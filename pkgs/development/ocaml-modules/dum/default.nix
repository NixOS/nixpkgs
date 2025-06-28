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
    --replace-fail "Lazy.lazy_is_val" "Lazy.is_val" \
    --replace-fail "Obj.final_tag" "Obj.custom_tag"
  '';

  propagatedBuildInputs = [ easy-format ];

  meta = {
    homepage = "https://github.com/mjambon/dum";
    description = "Inspect the runtime representation of arbitrary OCaml values";
    longDescription = ''
      Dum is a library for inspecting the runtime representation of
      arbitrary OCaml values. Shared or cyclic data are detected
      and labelled. This guarantees that printing would always
      terminate. This makes it possible to print values such as closures,
      objects or exceptions in depth and without risk.
    '';
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ alexfmpe ];
  };
}
