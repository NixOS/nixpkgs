import ./generic-builder.nix {
  version = "1.20.0-rc.1";
  hash = "sha256-FuTZHDI8ZNe6SHjiaPDZh21Ah7ek4kHqlYVvx0ybqI4=";
  # https://hexdocs.pm/elixir/1.20.0-rc.1/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "26";
  maximumOTPVersion = "28";
}
