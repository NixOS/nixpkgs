{ mkDerivation }:
mkDerivation {
  version = "1.17.1";
  sha256 = "sha256-a7A+426uuo3bUjggkglY1lqHmSbZNpjPaFpQUXYtW9k=";
  # https://hexdocs.pm/elixir/1.17.1/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
