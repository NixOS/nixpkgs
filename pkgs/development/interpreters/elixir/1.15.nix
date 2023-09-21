{ mkDerivation }:
mkDerivation {
  version = "1.15.6";
  sha256 = "sha256-eRwyqylldsJOsGAwm61m7jX1yrVDrTPS0qO23lJkcKc=";
  # https://hexdocs.pm/elixir/1.15.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "24";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
