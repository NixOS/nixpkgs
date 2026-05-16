{
  lib,
  perlPackages,
  fetchFromGitHub,
  installShellFiles,
}:

perlPackages.buildPerlPackage rec {
  pname = "wakeonlan";
  version = "0.42";

  src = fetchFromGitHub {
    owner = "jpoliv";
    repo = "wakeonlan";
    rev = "v${version}";
    sha256 = "sha256-zCOpp5iNrWwh2knBGWhiEyG9IPAnFRwH5jJLEVLBISM=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    perlPackages.TestPerlCritic
    perlPackages.TestPod
    perlPackages.TestPodCoverage
  ];
  # Linting and formatting checks are of no interest for us.
  preCheck = ''
    rm -f t/93_pod_spell.t
  '';

  installPhase = ''
    install -Dt $out/bin wakeonlan
    installManPage blib/man1/wakeonlan.1
  '';

  meta = {
    description = "Perl script for waking up computers via Wake-On-LAN magic packets";
    homepage = "https://github.com/jpoliv/wakeonlan";
    license = lib.licenses.artistic1;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "wakeonlan";
  };
}
