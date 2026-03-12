import ./generic-builder.nix {
  version = "1.20.0-rc.3";
  hash = "sha256-n0Y9HHb3sppliLMADUiNZKsNStghH8WwsOsjYzIzNoU=";
  # https://hexdocs.pm/elixir/1.20.0-rc.2/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  maximumOTPVersion = "28";
}
