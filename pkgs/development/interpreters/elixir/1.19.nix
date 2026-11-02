import ./generic-builder.nix {
  version = "1.19.7";
  hash = "sha256-P0VNvLQbjAyd/hj2MwoZ6vnZGl1QWXu006ojozayTds=";
  # https://hexdocs.pm/elixir/1.19.5/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  maximumOTPVersion = "28";
}
