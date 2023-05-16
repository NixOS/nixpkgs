<<<<<<< HEAD
{ lib, buildDunePackage, fetchurl, ppxlib, alcotest, mdx
=======
{ lib, buildDunePackage, fetchurl, ppxlib, alcotest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ppx_deriving, yaml
}:

buildDunePackage rec {
  pname = "ppx_deriving_yaml";
<<<<<<< HEAD
  version = "0.2.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/patricoferris/ppx_deriving_yaml/releases/download/v${version}/ppx_deriving_yaml-${version}.tbz";
    hash = "sha256-3vmay8UY7d3j96VOQ+D3oYEotzVls91F51ebXWQ/9SQ=";
=======
  version = "0.1.1";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/patricoferris/ppx_deriving_yaml/releases/download/v${version}/ppx_deriving_yaml-${version}.tbz";
    sha256 = "sha256-nR3568ULM6jaGG4H4+lLBTEJqh/ALHPiJxve40jPUxw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ ppxlib ppx_deriving yaml ];

  doCheck = true;
  checkInputs = [ alcotest ];
<<<<<<< HEAD
  nativeCheckInputs = [ mdx.bin ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "A YAML codec generator for OCaml";
    homepage = "https://github.com/patricoferris/ppx_deriving_yaml";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
