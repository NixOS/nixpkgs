{ mkDerivation }:
mkDerivation {
  version = "1.18.0";
  sha256 = "sha256-fT3J8h2uuJ+dSR58kwlUkN023yFlmTwq2/O12KbjJc4=";
  # https://hexdocs.pm/elixir/1.18.0/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
