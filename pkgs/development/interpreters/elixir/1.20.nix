import ./generic-builder.nix {
  version = "1.20.0";
  hash = "sha256-cTogrKyG2SkJFlnB43pwKiowf41eTHPTHbIS5f44b0Q=";
  # https://hexdocs.pm/elixir/1.20.0/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "27";
  maximumOTPVersion = "29";
}
