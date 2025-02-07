{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gitUpdater,
  testers,
  tkey-ssh-agent,
}:

buildGoModule rec {
  pname = "tkey-ssh-agent";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "tillitis";
    repo = "tkey-ssh-agent";
    rev = "v${version}";
    hash = "sha256-Uf3VJJfZn4UYX1q79JdaOfrore+L/Mic3whzpP32JV0=";
  };

  vendorHash = "sha256-SFyp1UB6+m7/YllRyY56SwweJ3X175bChXQYiG2M7zM=";

  subPackages = [
    "cmd/tkey-ssh-agent"
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
      tkey-ssh-agent-version = testers.testVersion {
        package = tkey-ssh-agent;
      };
    };
  };

  meta = with lib; {
    description = "SSH Agent for TKey, the flexible open hardware/software USB security key";
    homepage = "https://tillitis.se/app/tkey-ssh-agent/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
