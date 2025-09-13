{
  lib,
  rustPlatform,
  fetchFromGitHub,
  linux-doc,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "systeroid";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "systeroid";
    rev = "v${version}";
    sha256 = "sha256-Ip5zFyCMtTwfgY/XoHPOJq7VGCjZWVAgnjf6QsTG9go=";
  };

  postPatch = ''
    substituteInPlace systeroid-core/src/parsers.rs \
      --replace '"/usr/share/doc/kernel-doc-*/Documentation/*",' '"${linux-doc}/share/doc/linux-doc/*",'
  '';

  cargoHash = "sha256-Gce7DqhGD0CeBTPEqKhzdQ3IIHA6kjoWrejj4V8gT1I=";

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
