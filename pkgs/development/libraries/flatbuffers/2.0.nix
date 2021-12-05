{ callPackage, fetchpatch }:

callPackage ./generic.nix {
  version = "2.0.0";
  sha256 = "1zbf6bdpps8369r1ql00irxrp58jnalycc8jcapb8iqg654vlfz8";

  patches = [
    # Pull patch pending upstream inclustion for gcc-12 support:
    #  https://github.com/google/flatbuffers/pull/6946
    (fetchpatch {
      name = "gcc-12.patch";
      url =
        "https://github.com/google/flatbuffers/commit/17d9f0c4cf47a9575b4f43a2ac33eb35ba7f9e3e.patch";
      sha256 = "0sksk47hi7camja9ppnjr88jfdgj0nxqxy8976qs1nx73zkgbpf9";
    })
  ];
}
