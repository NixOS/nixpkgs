{ mkDerivation }:
mkDerivation {
  version = "1.17.2";
  sha256 = "sha256-8rb2f4CvJzio3QgoxvCv1iz8HooXze0tWUJ4Sc13dxg=";
  # https://hexdocs.pm/elixir/1.17.2/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
