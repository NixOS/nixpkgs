import ./generic-builder.nix {
  version = "1.19.5";
  hash = "sha256-ph7zu0F5q+/QZcsVIwpdU1icN84Rn3nIVpnRelpRIMQ=";
  # https://hexdocs.pm/elixir/1.19.5/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  maximumOTPVersion = "28";
}
