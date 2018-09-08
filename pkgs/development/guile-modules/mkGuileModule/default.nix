{ stdenv
, guile
, autoreconfHook
, pkgconfig
, texinfo
 }@default:

{ pname
, version
, src
, meta
, buildInputs ? []
, guile ? default.guile
}:

stdenv.mkDerivation {
  inherit src meta;

  name = "${pname}-${version}";

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    texinfo
  ];

  buildInputs = [
    guile
  ] ++ buildInputs;

  #setupHook = ./setup-hook.sh;
}


