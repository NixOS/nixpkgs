{ pycryptodome }:

(pycryptodome.overrideAttrs (oldAttrs: rec {
  pname = "pycryptodomex";

  postPatch = ''
    touch .separate_namespace
  '';

  pythonImportsCheck = [
    "Cryptodome"
  ];
}))
