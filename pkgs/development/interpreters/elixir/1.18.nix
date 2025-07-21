{ mkDerivation }:
mkDerivation {
  version = "1.18.4";
  sha256 = "sha256-PwogI+HfRXy5M7Xn/KyDjm5vUquTBoGxliSV0A2AwSA=";
  # https://hexdocs.pm/elixir/1.18.0/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
