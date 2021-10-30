# Older version of extlib for Haxe 4.0 and 4.1.
# May be replaceable by the next extlib + extlib-base64 release.
{ lib, fetchurl, ocaml, ocaml_extlib }:

ocaml_extlib.overrideAttrs (x: rec {
  version = "1.7.7";
  src = fetchurl {
    url = "https://github.com/ygrek/ocaml-extlib/releases/download/${version}/extlib-${version}.tar.gz";
    sha256 = "1sxmzc1mx3kg62j8kbk0dxkx8mkf1rn70h542cjzrziflznap0s1";
  };
  meta = x.meta // {
    broken = lib.versionAtLeast ocaml.version "4.12";
  };
})
