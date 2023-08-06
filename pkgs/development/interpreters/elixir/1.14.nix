{ mkDerivation }:

mkDerivation {
  version = "1.14.5";
  sha256 = "sha256-bCCTjFT+FG1hz+0H6k/izbCmi0JgO3Kkqc3LWWCs5Po=";
  # https://hexdocs.pm/elixir/1.14.5/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "23";
}
