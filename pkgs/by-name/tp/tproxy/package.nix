{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "tproxy";
<<<<<<< HEAD
  version = "0.9.2";
=======
  version = "0.9.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kevwan";
    repo = "tproxy";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-rVcPI0cB1TMiG4swdflOwFq+W23suM97qqPs6T4vmqw=";
  };

  vendorHash = "sha256-ygaRcSIYNesA1zWdUlL0AqSxec4dwIE0cbGImHX7+wU=";
=======
    hash = "sha256-Ck7WtCxWiZxkKlx7D/N0EZmFEgrW7MpPj5ATvJxGXgg=";
  };

  vendorHash = "sha256-xYPF3RGrOQ1e2EPHtvlM9QKSE+V4cnG8f9JTS0hkAYU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-w"
    "-s"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to proxy and analyze TCP connections";
    homepage = "https://github.com/kevwan/tproxy";
    changelog = "https://github.com/kevwan/tproxy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DCsunset ];
    mainProgram = "tproxy";
  };
}
