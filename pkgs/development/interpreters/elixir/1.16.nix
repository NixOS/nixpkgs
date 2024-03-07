{ mkDerivation }:
mkDerivation {
  version = "1.16.1";
  sha256 = "sha256-rjUt3gCUszCbzGE7BriwH3ptrV81dqNB/d0nVOXrcGI=";
  # https://hexdocs.pm/elixir/1.16.0/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "24";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
