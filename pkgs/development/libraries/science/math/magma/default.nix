{ callPackage ? (import <nixpkgs> {}).callPackage }:

let
  generic = args: callPackage (import ./generic.nix args) { };

  magma_2_0_2 = generic
    { version = "2.0.2"; sha256 = "0w3z6k1npfh0d3r8kpw873f1m7lny29sz2bvvfxzk596d4h083lk"; };
  magma_2_3_0 = generic
    { version = "2.3.0"; sha256 = "0256kvfng7i8grrn650mr49nkl7kb04zrgr6jixyb8bsgl2ll2h1"; };
  magma_2_4_0 = generic
    { version = "2.4.0"; sha256 = "0kws3ygidlc07xbldbvnz45h2xl4aznv9xd6r0lzs1al56qkkf2f"; };
in
{
  inherit
    magma_2_0_2
    magma_2_3_0
    magma_2_4_0;
  magma = magma_2_3_0;
}

