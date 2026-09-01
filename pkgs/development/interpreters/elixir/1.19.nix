import ./generic-builder.nix {
  version = "1.19.6";
  hash = "sha256-IpC1w3vKCKvEtmYqeYScChNWL7RXn/PjypUnLQt7IZc=";
  # https://hexdocs.pm/elixir/1.19.5/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  maximumOTPVersion = "28";
}
