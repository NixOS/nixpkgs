{ lib, buildHex }:

buildHex {
  name = "rebar3_proper";
  version = "0.12.1";
  hash = "sha256-ZpHE0Yg1Q1eCQNFX6qnUnz67MVaJL3wyDwcIaJYjJ7g=";

  meta = {
    description = "rebar3 proper plugin";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/ferd/rebar3_proper";
  };
}
