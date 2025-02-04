{ mkDerivation }:
mkDerivation {
  version = "1.18.2";
  sha256 = "sha256-8FhUKAaEjBBcF0etVPdkxMfrnR5niU40U8cxDRJdEok=";
  # https://hexdocs.pm/elixir/1.18.0/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
