import ./generic-builder.nix {
  version = "1.18.6";
  hash = "sha256-hpNv59DeRP6Uc7hRv5XQFWa0bTVBPzxaAD12253deh4=";
  # https://hexdocs.pm/elixir/1.18.0/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
}
