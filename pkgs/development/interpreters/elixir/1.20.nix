import ./generic-builder.nix {
  version = "1.20.3";
  hash = "sha256-60DlK+yocWcKnxcOtUOkRO69scaY35AADoKFCCF6QfQ=";
  # https://hexdocs.pm/elixir/1.20.3/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
  minimumOTPVersion = "27";
  maximumOTPVersion = "29";
}
