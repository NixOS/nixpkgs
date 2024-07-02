{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "libyaz0";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tyEjCcFEecJ+86SUXR6Nmxv8TKIXNNTkXlRpEbn6ptQ=";
    extension = "zip";
  };

  meta = {
    description = "A library for compressing/decompressing Yaz0/1 compression formats";
    homepage = "https://pypi.org/project/libyaz0/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ qubitnano ];
  };
}
