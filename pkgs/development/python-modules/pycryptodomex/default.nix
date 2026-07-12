{ pycryptodome }:

(pycryptodome.overrideAttrs (oldAttrs: {
  pname = "pycryptodomex";

  postPatch = ''
    touch .separate_namespace
  '';

  pythonImportsCheck = [ "Cryptodome" ];
}))
