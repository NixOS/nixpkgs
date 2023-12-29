{ mkDerivation }:
mkDerivation {
  version = "1.16.0";
  sha256 = "sha256-nM3TpX18zdjDAFkljsAqwKx/1AQmwDMIQCeL75etTQc=";
  # https://hexdocs.pm/elixir/1.16.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "24";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
