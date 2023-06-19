{ mkDerivation }:
mkDerivation {
  version = "1.15.0";
  sha256 = "sha256-o5MfA0UG8vpnPCH1EYspzcN62yKZQcz5uVUY47hOL9w=";
  # https://hexdocs.pm/elixir/1.15.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "24";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
