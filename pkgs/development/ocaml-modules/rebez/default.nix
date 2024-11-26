{ buildDunePackage, fetchFromGitHub, lib, reason }:

buildDunePackage rec {
  pname = "rebez";
  version = "unstable-2019-06-20";

  src = fetchFromGitHub {
    owner = "jchavarri";
    repo = "rebez";
    rev = "03fa3b707abb28fdd710eb9e57ba40d9cd6ae163";
    sha256 = "sha256-khZSwtwW+mP/EvAvIZMQyOb6FgNR+gmzpBZoD9ZPkpY=";
  };

  nativeBuildInputs = [ reason ];

  meta = with lib; {
    description = "Cubic bezier implementation in Reason / OCaml";
    homepage = "https://github.com/jchavarri/rebez/";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "RebezApp.exe";
  };
}
