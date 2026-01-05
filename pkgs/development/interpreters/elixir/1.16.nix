import ./generic-builder.nix {
  version = "1.16.3";
  hash = "sha256-WUBqoz3aQvBlSG3pTxGBpWySY7I0NUcDajQBgq5xYTU=";
  # https://hexdocs.pm/elixir/1.16.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "24";
  maximumOTPVersion = "26";
}
