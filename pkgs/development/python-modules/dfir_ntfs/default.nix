{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dfir-ntfs";
  version = "1.1.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "msuhanov";
    repo = "dfir_ntfs";
    tag = finalAttrs.version;
    hash = "sha256-iZd8qFLm77Fv8iUAB5M75u9a3SSBHqUEtZ8CPq8g7Ps=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # vsc_mount requires llfuse, which was removed from nixpkgs
  # https://github.com/msuhanov/dfir_ntfs/issues/15
  postInstall = ''
    rm $out/bin/vsc_mount
  '';

  meta = {
    description = "NTFS/FAT parser for digital forensics & incident response";
    homepage = "https://github.com/msuhanov/dfir_ntfs";
    changelog = "https://github.com/msuhanov/dfir_ntfs/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kyubai ];
  };
})
