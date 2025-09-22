{
  lib,
  buildPythonPackage,
  runCommand,
  fetchFromGitHub,
  rustPlatform,
  maturin,
  protobuf_30,
}:
buildPythonPackage rec {
  pname = "pyluwen";
  version = "0.7.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "luwen";
    tag = "v${version}";
    hash = "sha256-eQpKEeuy0mVrmu8ssAOWBcXi7zutStu+RbZOEF/IJ98=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-INzF8ORkrmPQMJbGSNm5QkfMOgE+HJ3taU1EZ9i+HJg=";
  };

  sourceRoot = "${src.name}/crates/${pname}";

  prePatch = ''
    chmod -R u+w ../../
    cd ../../
  '';

  postPatch = ''
    cd ../$sourceRoot
    cp --no-preserve=ownership,mode ../../Cargo.lock .
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    protobuf_30
  ];

  build-system = [ maturin ];

  meta = {
    description = "Tenstorrent system interface library";
    homepage = "https://github.com/tenstorrent/luwen";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
