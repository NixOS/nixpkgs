{ mkDerivation }:
mkDerivation {
  version = "1.15.5";
  sha256 = "sha256-2M1xen5gwmtOu4ug0XkxYke6h+Bw89JkpQGMDhbtNa0=";
  # https://hexdocs.pm/elixir/1.15.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "24";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
