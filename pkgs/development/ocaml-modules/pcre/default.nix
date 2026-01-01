{
  lib,
  buildDunePackage,
  fetchurl,
  pcre,
  dune-configurator,
}:

<<<<<<< HEAD
buildDunePackage (finalAttrs: {
  pname = "pcre";
  version = "8.0.5";

  src = fetchurl {
    url = "https://github.com/mmottl/pcre-ocaml/releases/download/${finalAttrs.version}/pcre-${finalAttrs.version}.tbz";
    hash = "sha256-7ZvPiNeBdnrWp8BICv8J1YifL8UA3aDRYgoXhtTkRJA=";
=======
buildDunePackage rec {
  pname = "pcre";
  version = "8.0.4";

  useDune2 = true;

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/mmottl/pcre-ocaml/releases/download/${version}/pcre-${version}.tbz";
    sha256 = "sha256-CIoy3Co4YnVZ5AkEjkUarqV0u08ZAqU0IQsaL1SnuCA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [ pcre ];

<<<<<<< HEAD
  meta = {
    homepage = "https://mmottl.github.io/pcre-ocaml";
    description = "Efficient C-library for pattern matching with Perl-style regular expressions in OCaml";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      vbmithr
    ];
  };
})
=======
  meta = with lib; {
    homepage = "https://mmottl.github.io/pcre-ocaml";
    description = "Efficient C-library for pattern matching with Perl-style regular expressions in OCaml";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      vbmithr
    ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
