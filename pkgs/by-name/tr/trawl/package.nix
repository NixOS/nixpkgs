{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gcc,
}:

rustPlatform.buildRustPackage rec {
  pname = "trawl";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "trawl";
    rev = "v${version}";
    hash = "sha256-QXUOh73N1lcvnWlRdqtyMioJSVTxVhLVliyzArVRaVc=";
  };

  cargoHash = "sha256-5kDWFJ6kmzrs5U1uOfmGTLE+z8DGcS+BIv8ZIUU4StA=";

  postPatch = ''
    substituteInPlace trawldb/src/{lib,parser}.rs \
    --replace "/usr/bin/cpp" "${lib.getExe' gcc "cpp"}"
    substituteInPlace trawld/src/{lib,parser,tests}.rs \
    --replace "/usr/bin/cpp" "${lib.getExe' gcc "cpp"}"
  '';

  doCheck = false;

  postInstall = ''
    mkdir -p $out/lib/systemd/user
    install -Dm644 trawld/trawld.service $out/lib/systemd/user/trawld.service
  '';

  meta = {
    description = "";
    homepage = "https://github.com/regolith-linux/trawl";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "trawl";
  };
}
