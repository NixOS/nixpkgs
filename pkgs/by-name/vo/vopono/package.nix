{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.13";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-xcxOdQyTNpC8Jhy8sE4AZPoFYTd/1gGdwMjc2W4S8Jc=";
  };

  cargoHash = "sha256-ZDnSI30pVyvBcVe8Yeug42LxPcdVK1axeBWcpaaXYJQ=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
    mainProgram = "vopono";
  };
}
