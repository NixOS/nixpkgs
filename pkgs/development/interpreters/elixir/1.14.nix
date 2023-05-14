{ mkDerivation }:

mkDerivation {
  version = "1.14.4";
  sha256 = "sha256-mV40pSpLrYKT43b8KXiQsaIB+ap+B4cS2QUxUoylm7c=";
  # https://hexdocs.pm/elixir/1.14.4/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "23";
}
