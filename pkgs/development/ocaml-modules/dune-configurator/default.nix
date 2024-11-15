{ lib, buildDunePackage, dune_3, csexp }:

buildDunePackage rec {
  pname = "dune-configurator";

  inherit (dune_3) src version;

  patches = dune_3.patches or [] ++ [
    # https://github.com/ocaml/dune/pull/11123
    # https://github.com/llvm/llvm-project/issues/116278
    ./clang-arg-order-workaround.patch
  ];

  # This fixes finding csexp
  postPatch = ''
    rm -rf vendor/pp vendor/csexp
  '';

  minimalOCamlVersion = "4.05";

  dontAddPrefix = true;

  propagatedBuildInputs = [ csexp ];

  meta = with lib; {
    description = "Helper library for gathering system configuration";
    maintainers = [ ];
    license = licenses.mit;
  };
}
