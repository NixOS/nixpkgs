{ mkDerivation }:
mkDerivation {
  version = "1.15.2";
  sha256 = "sha256-JLDjLO78p1i3FqGCbgl22SZFGPxJxKGKskzAJhHV8NE=";
  # https://hexdocs.pm/elixir/1.15.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "24";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
