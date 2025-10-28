import ./generic-builder.nix {
  version = "1.19.1";
  hash = "sha256-0rJx1BoJGDS0FsXyngBfQL3LhhNZvwh+TLQZjqOPFQw=";
  # https://hexdocs.pm/elixir/1.19.0-rc.1/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  maximumOTPVersion = "28";
}
