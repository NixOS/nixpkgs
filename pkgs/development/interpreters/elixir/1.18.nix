{ mkDerivation }:
mkDerivation {
  version = "1.18.1";
  sha256 = "sha256-zJNAoyqSj/KdJ1Cqau90QCJihjwHA+HO7nnD1Ugd768=";
  # https://hexdocs.pm/elixir/1.18.0/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
