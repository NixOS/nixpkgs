{ mkDerivation }:
mkDerivation {
  version = "1.17.0";
  sha256 = "sha256-RBylCfD+aCsvCqWUIvqXi3izNqqQoNfQNnQiZxz0Igg=";
  # https://hexdocs.pm/elixir/1.17.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
