{
  lib,
  rustPlatform,
  fetchFromGitHub,
  linux-doc,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "systeroid";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nyQFNPmPcguPGeArd+w1Jexj4/J53PXAeGDvoRSsh/k=";
  };

  postPatch = ''
    substituteInPlace systeroid-core/src/parsers.rs \
      --replace '"/usr/share/doc/kernel-doc-*/Documentation/*",' '"${linux-doc}/share/doc/linux-doc/*",'
  '';

  cargoHash = "sha256-ErNSsObo4Tbt9uvbIqOgR6dnSsL25urqocSGN/Won4A=";

  buildInputs = [
    xorg.libxcb
  ];

  # tries to access /sys/
  doCheck = false;

  meta = with lib; {
    description = "More powerful alternative to sysctl(8) with a terminal user interface";
    homepage = "https://github.com/orhun/systeroid";
    changelog = "https://github.com/orhun/systeroid/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
