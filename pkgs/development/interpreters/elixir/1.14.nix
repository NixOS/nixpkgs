{ mkDerivation }:

mkDerivation {
  version = "1.14.2";
  sha256 = "sha256-ABS+tXWm0vP3jb4ixWSi84Ltya7LHAuEkGMuAoZqHPA=";
  # https://hexdocs.pm/elixir/1.14.2/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "23";
}
