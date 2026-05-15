import ./generic-builder.nix {
  version = "1.20.0-rc.5";
  hash = "sha256-D1lYpwD/nb9GyCSW4W9mVliqULb7Hs641OdtwPDfsME=";
  # https://hexdocs.pm/elixir/1.20.0-rc.5/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "27";
  maximumOTPVersion = "29";
}
