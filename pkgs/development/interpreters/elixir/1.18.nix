import ./generic-builder.nix {
  version = "1.18.5";
  hash = "sha256-C7RXBjZZbdSgz4jdoOCKv8xfM95ChrYjXIIS/ahX+3Y=";
  # https://hexdocs.pm/elixir/1.18.0/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
}
