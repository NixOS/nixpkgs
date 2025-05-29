{
  buildXenPackage,
  python3Packages,
  fetchpatch,
}:

buildXenPackage.override { inherit python3Packages; } {
  pname = "xen";
  version = "4.19.1";
  patches = [
    (fetchpatch {
      url = "https://lore.kernel.org/xen-devel/e2caa6648a0b6c429349a9826d8fbc4338222482.1733766758.git.andrii.sultanov@cloud.com/raw";
      hash = "sha256-JC1ueXuC1Jdi2gtUsjOHmTeEx56zjotMMLde5vBonxc=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa467.patch";
      hash = "sha256-O2IwfRo6BnXAO04xjKmOyrV6J6Q1mAVLHWNCxqIEQGU=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.19-01.patch";
      hash = "sha256-YUcp9QI49RM/7WCxYzpzppv+vKtyl/NvLy6rIX5hVMw=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.19-02.patch";
      hash = "sha256-FTtEGAPFYxsun38hLhVMKJ1TFJOsTMK3WWPkO0R/OHg=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.19-03.patch";
      hash = "sha256-UkYMSpUgFvr4GJPXLgQsCyppGkNbeiFMyCZORK5tfmA=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.19-04.patch";
      hash = "sha256-lpiDPSHi+v2VfaWE9kp4+hveZKTzojD1F+RHsOtKE3A=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.19-05.patch";
      hash = "sha256-EKo9a5STX0mTRopoThe3+6gCWat+3XbguLr9QgMheZs=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.19-06.patch";
      hash = "sha256-HU+4apyTZNIFZ9cySOEtNh0JBJDG3LjDLwMvQYq0src=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.19-07.patch";
      hash = "sha256-9S85nkQ9Nn0cMzyRe4KGrFUaLggVxXBeKhoFF4R0y78=";
    })
  ];
  rev = "ccf400846780289ae779c62ef0c94757ff43bb60";
  hash = "sha256-s0eCBCd6ybl+kLtXCC6E1sk++w7txXn/B/Cg5acQFfY=";
}
