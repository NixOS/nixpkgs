# Older version of extlib for Haxe 4.0 and 4.1.
# May be replaceable by the next extlib + extlib-base64 release.
{ fetchurl, ocaml_extlib }:

ocaml_extlib.overrideAttrs (_: rec {
  version = "1.7.7";
  src = fetchurl {
    url = "https://github.com/ygrek/ocaml-extlib/releases/download/${version}/extlib-${version}.tar.gz";
    sha256 = "1sxmzc1mx3kg62j8kbk0dxkx8mkf1rn70h542cjzrziflznap0s1";
  };
})
