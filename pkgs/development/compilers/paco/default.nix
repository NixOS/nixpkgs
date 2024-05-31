{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "paco";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "pacolang";
    repo = "paco";
    rev = "v${version}";
    hash = "sha256-sCU7cjmsUTrhf/7Lm3wBPKwk80SAhCfc4lrCBggspw8=";
  };

  vendorHash = "sha256-J0TKp1df5IWq3Irlzf1lvhWlXnP//MsVqs9M8TtEraw=";

  patches = [
    # Set correct package path in go.mod
    (fetchpatch {
      url = "https://github.com/pacolang/paco/pull/1/commits/886f0407e94418d34c7e062c6857834aea3c99ac.patch";
      hash = "sha256-HRNJSyWz1OY+kCV+eaRJbaDXkH4n1NaMpFxCuEhocK4=";
    })
  ];

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A simple compiled programming language";
    mainProgram = "paco";
    homepage = "https://github.com/pacolang/paco";
    license = licenses.mit;
    maintainers = with maintainers; [ hugolgst ];
  };
}
