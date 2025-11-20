{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "wifitui";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "shazow";
    repo = "wifitui";
    tag = "v${version}";
    hash = "sha256-MC83hjeCxoP6xp0BfC7gsYZcGzgckWLpxAuXyuhWpn0=";
  };

  vendorHash = "sha256-SEQPc13cefzT8SyuD3UmNtTDgcrXUGTX54SBrnOHJJw=";

  meta = with lib; {
    description = "Fast featureful friendly wifi terminal UI";
    homepage = "https://github.com/shazow/wifitui";
    license = licenses.mit;
    maintainers = with maintainers; [
      greed
      shazow
    ];
  };
}
