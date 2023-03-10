{ pycryptodome }:

(pycryptodome.overrideAttrs (_: rec {
  pname = "pycryptodomex";

  postPatch = ''
    touch .separate_namespace
  '';

  pythonImportsCheck = [
    "Cryptodome"
  ];
}))
