import ./generic-builder.nix {
  version = "1.20.0-rc.2";
  hash = "sha256-un0F3EIwFJn/aeIHxlnlOWn41y1JCPtl+Xm+HSk03OE=";
  # https://hexdocs.pm/elixir/1.20.0-rc.2/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  maximumOTPVersion = "28";
}
