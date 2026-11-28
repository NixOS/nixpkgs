{
  buildDunePackage,
  cascade,
  cmdliner,
  fetchFromGitHub,
  fmt,
  lib,
  re,
}:

buildDunePackage (finalAttrs: {
  pname = "tw";
  version = "1.2.0";
  minimalOCamlVersion = "5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "samoht";
    repo = "tw";
    tag = finalAttrs.version;
    hash = "sha256-lmEAl9XDKSAcT4qHpTTGienKcMUjqvYgrdPmXteHKAo=";
  };

  propagatedBuildInputs = [ cascade ];
  buildInputs = [
    cmdliner
    fmt
    re
  ];

  # Disabling tests because they check for byte-for-byte identical
  # output with tailwindcss, so they are tied to a specific
  # tailwindcss version, and would prevent independent upgrades of tw
  # and tailwindcss.
  doCheck = false;

  meta = {
    description = "Type-safe Tailwind CSS v4 in OCaml";
    homepage = "https://github.com/samoht/tw";
    mainProgram = "tw";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vog ];
  };
})
