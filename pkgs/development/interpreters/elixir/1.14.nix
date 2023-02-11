{ mkDerivation }:

mkDerivation {
  version = "1.14.3";
  sha256 = "sha256-8rkuyAQAZdaKFXnSMaIPwbgoHnPs+nJ+mdbqcqYNeE4=";
  # https://hexdocs.pm/elixir/1.14.3/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "23";
}
