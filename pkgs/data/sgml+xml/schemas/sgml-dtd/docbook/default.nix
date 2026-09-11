{
  callPackage,
}:
{
  docbook_sgml_dtd_31 = callPackage (import ./generic.nix {
    version = "3.1";
    hash = "sha256-ICYdJ3G5oFKr+j2PqxqmK+BXkaAQKBxWb5Bzvw5kRTg=";
  }) { };
  docbook_sgml_dtd_41 = callPackage (import ./generic.nix {
    version = "4.1";
    hash = "sha256-3qr88KNndpLnrUQSwOQcHbPp2mzc2z3TKyzB+cl9YxE=";
  }) { };
  docbook_sgml_dtd_45 = callPackage (import ./generic.nix {
    version = "4.5";
    hash = "sha256-gEPlFOgMbBnLFGtdN5N9EwW/Or+bAJfDbff3D2Ec30M=";
  }) { };
}
