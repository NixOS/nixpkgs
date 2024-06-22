import ./generic.nix {
  major_version = "4";
  minor_version = "10";
  patch_version = "2";
  sha256 = "sha256-locUYQeCgtXbAiB32JveJchfteN2YStE+MN9ToTwAOM=";
  patches = [
    ./glibc-2.34-for-ocaml-4.10-and-11.patch
  ];
}
