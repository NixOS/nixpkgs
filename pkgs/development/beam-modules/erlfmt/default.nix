{ fetchFromGitHub, rebar3Relx, lib }:

rebar3Relx rec {
  pname = "erlfmt";
  version = "1.0.0";
  releaseType = "escript";
  src = fetchFromGitHub {
    owner = "WhatsApp";
    repo = "erlfmt";
    sha256 = "19apbs9xr4j8qjb3sv9ilknqjw4a7bvp8jvwrjiwvwnxzzm2kjm6";
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
