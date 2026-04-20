import ./generic-builder.nix {
  version = "1.20.0-rc.4";
  hash = "sha256-sboB+GW3T+t9gEcOGtd6NllmIlyWio1+cgWyyxE+484=";
  # https://hexdocs.pm/elixir/1.20.0-rc.4/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "27";
  maximumOTPVersion = "29";
}
