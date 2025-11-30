{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  prelude,
}:

buildDunePackage rec {
  pname = "synchronizer";
  version = "0.1";

  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "synchronizer";
    tag = version;
    hash = "sha256-VlKqORXTXafT88GXHIYkz+A1VkEL3jP9SMqDdMyEdrw=";
  };

  propagatedBuildInputs = [
    prelude
  ];

  meta = {
    homepage = "https://github.com/OCamlPro/synchronizer";
    description = "Synchronizer to make datastructures thread-safe";
    changelog = "https://raw.githubusercontent.com/OCamlPro/synchronizer/${src.rev}/CHANGES.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ redianthus ];
  };
}
