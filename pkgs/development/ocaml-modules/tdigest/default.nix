{ lib, fetchFromGitHub, nix-update-script
, buildDunePackage
, core
}:

buildDunePackage rec {
  pname = "tdigest";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "SGrondin";
    repo = pname;
    rev = version;
    sha256 = "sha256-pkJRJeEbBbAR1STb6v3Zu11twvHkAKAO0YjifRBFTDw=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    core
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/SGrondin/${pname}";
    description = "OCaml implementation of the T-Digest algorithm";
    license = licenses.mit;
    maintainers = with maintainers; [ niols ];
  };
}
