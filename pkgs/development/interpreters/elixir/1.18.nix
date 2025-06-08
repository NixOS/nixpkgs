{ mkDerivation }:
mkDerivation {
  version = "1.19-latest";
  sha256 = "sha256-B/KDv0JXh0B10AEMszkU0uXpdtlasSXqg7wjbGmL6dw=";
  # https://hexdocs.pm/elixir/1.18.0/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
