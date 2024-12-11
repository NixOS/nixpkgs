{ mkDerivation }:
mkDerivation {
  version = "1.18-latest";
  sha256 = "sha256-dSBQHqS7e9Y/0+XlD8xfER//brkaGPv4TcGYbUrxSj8=";
  # https://hexdocs.pm/elixir/1.18-latest/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
