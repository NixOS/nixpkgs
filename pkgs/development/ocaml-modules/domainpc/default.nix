{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  processor,
}:

buildDunePackage (finalAttrs: {
  pname = "domainpc";
  version = "0.2";

  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = "domainpc";
    tag = finalAttrs.version;
    hash = "sha256-VyCbxVikV0+YZzgC/8i4RLxVWN3TMS6n0qR72SmVwI8=";
  };

  propagatedBuildInputs = [
    processor
  ];

  meta = {
    description = "Domain Per Core, spawn domains ensuring that they run on separate cores";
    homepage = "https://github.com/ocamlpro/domainpc";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
