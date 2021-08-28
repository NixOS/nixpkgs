{ lib, buildRebar3, fetchFromGitHub }:
buildRebar3 rec {
  name = "rebar3_nix";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "erlang-nix";
    repo = name;
    rev = "v${version}";
    sha256 = "17w8m4aqqgvhpx3xyc7x2qzsrd3ybzc83ay50zs1gyd1b8csh2wf";
  };

  meta = {
    description = "nix integration for rebar3";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/erlang-nix/rebar3_nix";
    maintainers = with lib.maintainers; [ dlesl gleber ];
  };
}
