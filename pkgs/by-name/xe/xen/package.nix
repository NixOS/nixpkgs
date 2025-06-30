{
  buildXenPackage,
  python3Packages,
  fetchpatch,
}:

buildXenPackage.override { inherit python3Packages; } {
  pname = "xen";
  version = "4.19.2";
  patches = [
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
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa470.patch";
      hash = "sha256-zhMZ6pCZtt0ocgsMFVqthMaof46lMMTaYmlepMXVJqM=";
    })
  ];
  rev = "f3362182e028119e5ca2ab37e5628b9fa6d21254";
  hash = "sha256-c6LXYJ61umJb/r5/utwBWLAfy+tIvpK7QLjI3zKfr6Y=";
}
