{ lib, buildHex }:

buildHex {
  name = "pc";
  version = "1.15.0";
  sha256 = "sha256-TA+tT2Q3yuNT1RfaIY/ng0e4/6RLmBeIdJTKquVFlbM=";

  meta = {
    description = "Rebar3 port compiler for native code";
    license = lib.licenses.mit;
    homepage = "https://github.com/blt/port_compiler";
  };
}
