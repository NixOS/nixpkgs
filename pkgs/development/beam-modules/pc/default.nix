{ lib, buildHex }:

buildHex {
  name = "pc";
  version = "1.12.0";
  sha256 = "1gdvixy4j560qjdiv5qjgnl5wl3rrn231dv1m4vdq4b9l4g4p27x";

  meta = {
    description = "a rebar3 port compiler for native code";
    license = lib.licenses.mit;
    homepage = "https://github.com/blt/port_compiler";
  };
}
