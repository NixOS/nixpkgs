{ stdenv
, lib
, fetchFromSourcehut
, autoreconfHook
, pkg-config
, check
}:

stdenv.mkDerivation rec {
  pname = "wwcd";
  version = "unstable-2022-02-05";

  src = fetchFromSourcehut {
    owner = "~bitfehler";
    repo = pname;
    rev = "cdf70bb18dc60c66c074d4810cb37b9e697811e5";
    sha256 = "sha256-laf1DEtdEs7q+rtp5Y5rb+7AGsKUv5T413CFWJiURWw=";
  };

  nativeBuildInputs = [
    autoreconfHook pkg-config check
  ];

  autoreconfFlags = [ "-if" ];

  meta = with lib; {
    description = "What would cron do? Read crontab entries from stdin and print time of next execution(s)";
    homepage = "https://git.sr.ht/~bitfehler/wwcd";
    license = licenses.mit;
    maintainers = with maintainers; [ laalsaas ];
    mainProgram = "wwcd";
  };
}
