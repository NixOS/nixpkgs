{ fetchFromGitHub, rebar3Relx, lib }:

rebar3Relx rec {
  pname = "erlfmt";
  version = "1.2.0";
  releaseType = "escript";
  src = fetchFromGitHub {
    owner = "WhatsApp";
    repo = "erlfmt";
    sha256 = "sha256-mma4QH6GlayTG5I9hW9wNZph/IJcCXjiY7Ft3hfxaPg=";
    rev = "v${version}";
  };
  meta = with lib; {
    homepage = "https://github.com/WhatsApp/erlfmt";
    description = "An automated code formatter for Erlang";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
