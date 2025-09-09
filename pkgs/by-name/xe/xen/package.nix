{
  buildXenPackage,
  fetchpatch,
  python3Packages,
}:

buildXenPackage.override { inherit python3Packages; } {
  pname = "xen";
  version = "4.19.3";
  rev = "077419f04a3125c58dcf9724c954f98d1e927392";
  hash = "sha256-e9aPLgzNVxUn7WnLbBHwFIN02DAObfA24VjiqdiP+jA=";

  patches = [
    # XSA 472
    (fetchpatch {
      url = "https://xenbits.xen.org/xsa/xsa472-1.patch";
      hash = "sha256-6k/X7KFno9uBG0mUtJxl7TMavaRs2Xlj9JlW9ai6p0k=";
    })
    (fetchpatch {
      url = "https://xenbits.xen.org/xsa/xsa472-2.patch";
      hash = "sha256-BisdztU9Wa5nIGmHo4IikqYPHdEhBehHaNqj1IuBe6I=";
    })
    (fetchpatch {
      url = "https://xenbits.xen.org/xsa/xsa472-3.patch";
      hash = "sha256-rikOofQeuLNMBkdQS3xzmwh7BlgMOTMSsQcAOEzNOso=";
    })
  ];
}
