{ mkDerivation }:
mkDerivation {
  version = "1.15.7";
  sha256 = "sha256-6GfZycylh+sHIuiQk/GQr1pRQRY1uBycSQdsVJ0J13k=";
  # https://hexdocs.pm/elixir/1.15.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "24";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
