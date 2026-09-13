{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  ocaml,
  cppo,
}:

buildDunePackage (finalAttrs: {
  pname = "memprof-limits";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "gadmm";
    repo = "memprof-limits";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k/uB1jDQtE/PkVPU8zg8cpOmlPttTWVpKerQ0HuWfuI=";
  };

  minimalOCamlVersion = "4.12";

  nativeBuildInputs = [
    cppo
  ];

  meta = {
    homepage = "https://ocaml.org/p/memprof-limits/latest";
    description = "Memory limits, allocation limits, and thread cancellation for OCaml";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ alizter ];
  };
})
