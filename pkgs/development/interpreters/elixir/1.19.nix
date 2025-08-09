{ mkDerivation }:
mkDerivation {
  version = "1.19.0-rc.0";
  sha256 = "sha256-9Upk3DLxFVetK3fChLr0UjRi2WnvSndVvBW0RfM5hTk=";
  # https://hexdocs.pm/elixir/1.19.0-rc.0/compatibility-and-deprecations.html#table-of-deprecations
  minimumOTPVersion = "26";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
