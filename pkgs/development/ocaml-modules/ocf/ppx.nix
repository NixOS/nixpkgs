{
  fetchpatch,
  buildDunePackage,
  ocf,
  ppxlib,
}:

buildDunePackage {
  pname = "ocf_ppx";
  minimalOCamlVersion = "4.11";

  inherit (ocf) src version;

  patches = [
    # Support for ppxlib ≥ 0.37
    (fetchpatch {
      url = "https://framagit.org/zoggy/ocf/-/commit/38b1f6420e5c01b3ea6b2fed99b6b62e4c848dc0.patch";
      hash = "sha256-GymTdK/dOYGianvNIKkl9OhBGW+4dX5TqAkQuEF5FmA=";
      includes = [ "*.ml" ];
    })
  ];

  buildInputs = [
    ppxlib
    ocf
  ];

  meta = ocf.meta // {
    description = "Preprocessor for Ocf library";
  };
}
