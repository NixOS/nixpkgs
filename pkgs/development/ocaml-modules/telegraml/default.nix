{ batteries
, buildDunePackage
, cohttp-lwt-unix
, fetchFromGitHub
, lib
, logs
, yojson
}:

buildDunePackage rec {
  pname = "telegraml";
  version = "unstable-2021-06-17";

  src = fetchFromGitHub {
    owner = "nv-vn";
    repo = "TelegraML";
    rev = "3e28933a287e5eacd34c46b434c487f155397abc";
    sha256 = "sha256-2bMHARatwl8Zl/fWppvwbH6Ut+igJVKzwyQb8Q4gem4=";
  };

  postPatch = ''
    substituteInPlace src/dune --replace batteries batteries.unthreaded
  '';

  propagatedBuildInputs = [
    batteries
    cohttp-lwt-unix
    logs
    yojson
  ];

  meta = with lib; {
    description = "An OCaml library implementing the Telegram bot API";
    homepage = "https://github.com/nv-vn/TelegraML/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
