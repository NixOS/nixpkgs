import ./generic-builder.nix {
  version = "1.20.4";
  hash = "sha256-Z/lAmD3wyiTnX2e7n2gHELkTpZ3AgGSjqNmvDxCH91g=";
  # https://hexdocs.pm/elixir/1.20.3/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "27";
  maximumOTPVersion = "29";
}
