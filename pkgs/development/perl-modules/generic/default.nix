perl:

attrs:

perl.stdenv.mkDerivation (attrs // {
  builder = ./builder.sh;
  buildInputs = [(if attrs ? buildInputs then attrs.buildInputs else []) perl];
})
