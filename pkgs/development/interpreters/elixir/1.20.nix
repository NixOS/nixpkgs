import ./generic-builder.nix {
  version = "1.20.2";
  hash = "sha256-KSRsXQhh3PX7SUNhuw/POg74XfjkPiZDsv9wdNwFrwA=";
  # https://hexdocs.pm/elixir/1.20.0/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "27";
  maximumOTPVersion = "29";
}
