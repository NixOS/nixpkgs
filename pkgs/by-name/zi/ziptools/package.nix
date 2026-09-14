{
  lib,
  stdenvNoCC,
  zig_0_15,
  fetchFromGitHub,
  installSymlinks ? true,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ziptools";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "RossComputerGuy";
    repo = "ziptools";
    tag = finalAttrs.version;
    hash = "sha256-oxlqNYaHLylzSdmejzzfs8Csiza5CR27iFO0PCFEGZE=";
  };

  nativeBuildInputs = [
    zig_0_15
    zig_0_15.hook
  ];

  postInstall = lib.optionalString installSymlinks ''
    ln -s $out/bin/ziptools $out/bin/zip
    ln -s $out/bin/ziptools $out/bin/unzip
  '';

  meta = {
    description = "Modern zip & unzip replacements";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    homepage = "https://github.com/RossComputerGuy/ziptools";
    changelog = "https://github.com/RossComputerGuy/ziptools/commits/${finalAttrs.version}";
  };
})
