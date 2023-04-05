{ pycryptodome }:

(pycryptodome.overrideAttrs (_oldAttrs: rec {
  pname = "pycryptodomex";

  postPatch = ''
    touch .separate_namespace
  '';

  pythonImportsCheck = [
    "Cryptodome"
  ];
}))
