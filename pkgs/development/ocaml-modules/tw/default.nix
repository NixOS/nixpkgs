{
  buildDunePackage,
  cascade,
  cmdliner,
  fetchFromGitHub,
  fmt,
  lib,
  ocaml,
}:

buildDunePackage (finalAttrs: {
  pname = "tw";
  version = "0-unstable-2026-06-23";
  minimalOCamlVersion = "5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "samoht";
    repo = "tw";
    rev = "594d35df46ec2afcfe97632923331badf2940b93";
    hash = "sha256-vCRq0FCBIxc/AQg+R2Hig7nqwJGxgy2jedLbAsKaIoA=";
  };

  propagatedBuildInputs = [ cascade ];
  buildInputs = [
    cmdliner
    fmt
  ];

  # Disabling tests because they check for byte-for-byte identical
  # output with tailwindcss, so they are tied to a specific
  # tailwindcss version, and would prevent independent upgrades of tw
  # and tailwindcss.
  doCheck = false;

  outputs = [
    "bin"
    "lib"
    "out"
  ];

  installPhase = ''
    runHook preInstall
    dune install --prefix=$bin --libdir=$lib/lib/ocaml/${ocaml.version}/site-lib
    runHook postInstall
  '';

  meta = {
    description = "Type-safe Tailwind CSS v4 in OCaml";
    homepage = "https://github.com/samoht/tw";
    mainProgram = "tw";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vog ];
  };
})
