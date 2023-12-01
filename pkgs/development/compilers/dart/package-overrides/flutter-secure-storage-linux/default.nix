{ lib
, pkg-config
, libsecret
, jsoncpp
}:

{ ... }:

{ nativeBuildInputs ? [ ]
, buildInputs ? [ ]
, ...
}:

{
  nativeBuildInputs = [ pkg-config ] ++ nativeBuildInputs;
  buildInputs = [ libsecret jsoncpp ] ++ buildInputs;
}
