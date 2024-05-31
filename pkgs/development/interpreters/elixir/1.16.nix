{ mkDerivation }:
mkDerivation {
  version = "1.16.3";
  sha256 = "sha256-WUBqoz3aQvBlSG3pTxGBpWySY7I0NUcDajQBgq5xYTU=";
  # https://hexdocs.pm/elixir/1.16.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "24";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
