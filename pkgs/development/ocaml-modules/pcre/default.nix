{
  lib,
  buildDunePackage,
  fetchurl,
  pcre,
  dune-configurator,
}:

buildDunePackage (finalAttrs: {
  pname = "pcre";
  version = "8.0.5";

  src = fetchurl {
    url = "https://github.com/mmottl/pcre-ocaml/releases/download/${finalAttrs.version}/pcre-${finalAttrs.version}.tbz";
    hash = "sha256-7ZvPiNeBdnrWp8BICv8J1YifL8UA3aDRYgoXhtTkRJA=";
  };

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [ pcre ];

  meta = {
    homepage = "https://mmottl.github.io/pcre-ocaml";
    description = "Efficient C-library for pattern matching with Perl-style regular expressions in OCaml";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      vbmithr
    ];
  };
})
