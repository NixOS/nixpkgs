import ./generic-builder.nix {
  version = "1.20.0-rc.6";
  hash = "sha256-U3zBeZ4U44jXwYJva2neb3Ll1dDpxvLSIR0Tg1HP33U=";
  # https://hexdocs.pm/elixir/1.20.0-rc.6/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "27";
  maximumOTPVersion = "29";
}
