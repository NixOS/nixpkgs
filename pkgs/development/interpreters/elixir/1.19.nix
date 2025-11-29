import ./generic-builder.nix {
  version = "1.19.4";
  hash = "sha256-lJC/xXkVIsX6AgL3ynU6C9AncBDwHPsUGxyYlTRdaMY=";
  # https://hexdocs.pm/elixir/1.19.0-rc.1/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  maximumOTPVersion = "28";
}
