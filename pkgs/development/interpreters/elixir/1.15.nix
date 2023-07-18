{ mkDerivation }:
mkDerivation {
  version = "1.15.4";
  sha256 = "sha256-0DrfKQPyFX+zurCIZ6RVj9vm1lHSkJSfhiUaRpa3FFo=";
  # https://hexdocs.pm/elixir/1.15.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "24";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
