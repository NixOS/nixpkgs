{ mkDerivation }:
mkDerivation {
  version = "1.17.3";
  sha256 = "sha256-7Qo6y0KAQ9lwD4oH+7wQ4W5i6INHIBDN9IQAAsYzNJw=";
  # https://hexdocs.pm/elixir/1.17.3/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp
  minimumOTPVersion = "25";
  escriptPath = "lib/elixir/scripts/generate_app.escript";
}
