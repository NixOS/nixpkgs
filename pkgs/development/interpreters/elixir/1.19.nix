import ./generic-builder.nix {
  version = "1.19.3";
  hash = "sha256-hO9dggp9qQu9RhDSdzUtTGjHBDXpf92JeWWcDOwOsPg=";
  # https://hexdocs.pm/elixir/1.19.0-rc.1/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  maximumOTPVersion = "28";
}
