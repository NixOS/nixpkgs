{ pycryptodome_3 }:

(pycryptodome_3.overrideAttrs (oldAttrs: {
  pname = "pycryptodomex";

  postPatch = ''
    touch .separate_namespace
  '';

  pythonImportsCheck = [ "Cryptodome" ];
}))
