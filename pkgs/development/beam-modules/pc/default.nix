{ stdenv, buildHex }:

buildHex {
  name = "pc";
  version = "1.6.0";
  sha256 = "0xq411ig5ny3iilkkkqa4vm3w3dgjc9cfzkqwk8pm13dw9mcm8h0";

  meta = {
    description = ''a rebar3 port compiler for native code'';
    license = stdenv.lib.licenses.mit;
    homepage = "https://github.com/blt/port_compiler";
  };
}
