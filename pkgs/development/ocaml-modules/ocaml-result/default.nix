{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  pname = "result";
  version = "1.5";

  src = fetchurl {
    url = "https://github.com/janestreet/result/releases/download/${finalAttrs.version}/result-${finalAttrs.version}.tbz";
    hash = "sha256-fDpeI4VY9MGk9azKgWvHBaDhL2jcAAXGHdvy5sq47jI=";
  };

  meta = {
    homepage = "https://github.com/janestreet/result";
    description = "Compatibility Result module";
    longDescription = ''
      Projects that want to use the new result type defined in OCaml >= 4.03
      while staying compatible with older version of OCaml should use the
      Result module defined in this library.
    '';
    license = lib.licenses.bsd3;
  };
})
