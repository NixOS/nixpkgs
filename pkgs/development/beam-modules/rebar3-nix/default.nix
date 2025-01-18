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
    sha256 = "10ijc06qvv5hqv0qy3w7mbv9pshdb8bvy0f3phr1vd5hksbk731y";
  };

  meta = with lib; {
    description = "nix integration for rebar3";
    license = licenses.bsd3;
    homepage = "https://github.com/erlang-nix/rebar3_nix";
    maintainers = with maintainers; [
      dlesl
      gleber
    ];
  };
}
