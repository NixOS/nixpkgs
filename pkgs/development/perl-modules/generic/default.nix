perl:

attrs:

perl.stdenv.mkDerivation (attrs // {
  name = "perl-" + attrs.name;
  builder = ./builder.sh;
  buildInputs = [(if attrs ? buildInputs then attrs.buildInputs else []) perl];
})
