{ fetchFromGitHub, rebar3Relx, lib }:

rebar3Relx rec {
  pname = "erlfmt";
  version = "1.1.0";
  releaseType = "escript";
  src = fetchFromGitHub {
    owner = "WhatsApp";
    repo = "erlfmt";
    sha256 = "sha256-diZCyw4eR+h/Pc73HDfnFaXnNXwqu3XabTbeiWVPNPI=";
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
