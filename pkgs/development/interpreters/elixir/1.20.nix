import ./generic-builder.nix {
  version = "1.20.1";
  hash = "sha256-eOYqYcZpHJqgbut0iOrey6CMD3LIvpqc3AU9L/g7a+Y=";
  # https://hexdocs.pm/elixir/1.20.0/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "27";
  maximumOTPVersion = "29";
}
