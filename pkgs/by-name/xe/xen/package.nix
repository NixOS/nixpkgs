{
  buildXenPackage,
  python3Packages,
  fetchpatch,
}:

buildXenPackage.override { inherit python3Packages; } {
  pname = "xen";
  version = "4.20.0";
  patches = [
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-01.patch";
      hash = "sha256-go743oBhYDuxsK0Xc6nK/WxutQQwc2ERtLKhCU9Dnng=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-02.patch";
      hash = "sha256-FTtEGAPFYxsun38hLhVMKJ1TFJOsTMK3WWPkO0R/OHg=sha256-FTtEGAPFYxsun38hLhVMKJ1TFJOsTMK3WWPkO0R/OHg=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-03.patch";
      hash = "sha256-UkYMSpUgFvr4GJPXLgQsCyppGkNbeiFMyCZORK5tfmA=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-04.patch";
      hash = "sha256-lpiDPSHi+v2VfaWE9kp4+hveZKTzojD1F+RHsOtKE3A=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-05.patch";
      hash = "sha256-N+WR8S5w9dLISlOhMI71TOH8jvCgVAR8xm310k3ZA/M=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-06.patch";
      hash = "sha256-ePuyB3VP9NfQbW36BP3jjMMHKJWFJGeTYUYZqy+IlHQ=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-07.patch";
      hash = "sha256-+BsCJa01R2lrbu7tEluGrYSAqu2jJcrpFNUoLMY466c=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa470.patch";
      hash = "sha256-zhMZ6pCZtt0ocgsMFVqthMaof46lMMTaYmlepMXVJqM=";
    })
  ];
  rev = "3ad5d648cda5add395f49fc3704b2552aae734f7";
  hash = "sha256-v2DRJv+1bym8zAgU74lo1HQ/9rUcyK3qc4Eec4RpcEY=";
}
