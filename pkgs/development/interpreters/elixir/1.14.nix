{ mkDerivation }:

mkDerivation {
  version = "1.14.0";
  sha256 = "16rc4qaykddda6ax5f8zw70yhapgwraqbgx5gp3f40dvfax3d51l";
  # https://hexdocs.pm/elixir/1.14.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "23";
}
