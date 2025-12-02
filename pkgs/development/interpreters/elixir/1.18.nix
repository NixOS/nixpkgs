import ./generic-builder.nix {
  version = "1.18.4";
  hash = "sha256-PwogI+HfRXy5M7Xn/KyDjm5vUquTBoGxliSV0A2AwSA=";
  # https://hexdocs.pm/elixir/1.18.0/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
}
