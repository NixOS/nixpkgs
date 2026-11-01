import ./generic-builder.nix {
  version = "1.20.5";
  hash = "sha256-MsRNaWAQ05ysL3hOqpfhm//tRNL0Z4Ia/NfEWEQfEWE=";
  # https://hexdocs.pm/elixir/1.20.3/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "27";
  maximumOTPVersion = "29";
}
