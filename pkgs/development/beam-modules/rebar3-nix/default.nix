{
  lib,
  buildRebar3,
  fetchFromGitHub,
}:
buildRebar3 rec {
  name = "rebar3_nix";
  version = "0.1.1";
  src = fetchFromGitHub {
    owner = "erlang-nix";
    repo = name;
    rev = "v${version}";
    hash = "sha256-Powzl56wtB0yvMMBvxdaDeqb9qqHD4/BxrDsjQ1gMoI=";
  };

  meta = {
    description = "nix integration for rebar3";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/erlang-nix/rebar3_nix";
    maintainers = with lib.maintainers; [
      dlesl
      gleber
    ];
  };
}
