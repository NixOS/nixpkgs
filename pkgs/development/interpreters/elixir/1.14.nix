{ mkDerivation }:

mkDerivation {
  version = "1.14.1";
  sha256 = "sha256-/QQckiRvwmD3gdIo19TXM0bIgdxNx8eQwpd1RnEo35A=";
  # https://hexdocs.pm/elixir/1.14.1/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "23";
}
