{ mkDerivation }:
mkDerivation {
  version = "1.19.0";
  sha256 = "sha256-d5ForVzRlj/OpusNNKIuTiNeiumqtruitxlVmvraah4=";
  # https://hexdocs.pm/elixir/1.19.0-rc.1/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  maximumOTPVersion = "28";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
