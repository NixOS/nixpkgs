{ mkDerivation }:
mkDerivation {
  version = "1.16.2";
  sha256 = "sha256-NUYYxf73Fuk3FUoVFKTo6IN9QCTvzz5wNshIf/nitJA=";
  # https://hexdocs.pm/elixir/1.16.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "24";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
