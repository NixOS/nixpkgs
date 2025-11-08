import ./generic-builder.nix {
  version = "1.19.2";
  hash = "sha256-sJNwWl6iCWzf8iDVG90DUxU8H3piKyGoU0mIAqfsphQ=";
  # https://hexdocs.pm/elixir/1.19.0-rc.1/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  maximumOTPVersion = "28";
}
