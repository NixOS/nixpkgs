{ mkDerivation }:
mkDerivation {
  version = "1.19.0-rc.1";
  sha256 = "sha256-GqnIVktRWT7f73a1EolFbKi70fz0ncuyqh3gl/17Zh0=";
  # https://hexdocs.pm/elixir/1.19.0-rc.1/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
