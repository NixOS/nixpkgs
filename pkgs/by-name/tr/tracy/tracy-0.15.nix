{
  fetchFromGitHub,

  pugixml,
  curl,
  zstd,
  nlohmann_json,
  html-tidy,
  python3,
  pandoc,
}:
{
  version = "0.15.0";
  srcHash = "sha256-Jzlw1wXNQ/pYhIK+jN47SGCMPftdH4QoDrmh36++VXE=";
  patches = [
    ./any-pandoc.patch
  ];
  extraBuildInputs = [
    pugixml
    curl
    zstd
    nlohmann_json
    html-tidy
    python3
    pandoc
  ];
  cpmSrcs = [
    (fetchFromGitHub {
      name = "ImGui";
      owner = "ocornut";
      repo = "imgui";
      rev = "v1.93.0-docking";
      hash = "sha256-NCD0li4ECPSFhhU0egSWMiYNBKSJDoB80rSOUiRAQ6c=";
    })
    (fetchFromGitHub {
      name = "nfd";
      owner = "btzy";
      repo = "nativefiledialog-extended";
      rev = "v1.4.1";
      fetchSubmodules = true;
      hash = "sha256-zyVosxjbW4lHT/SNFr0PbeY5conpn9hTfZkxn2kxDQE=";
    })
    (fetchFromGitHub {
      name = "md4c";
      owner = "mity";
      repo = "md4c";
      rev = "60e8065cfccd5d7ac561115f9a9bfbdf811f5cc9";
      hash = "sha256-rYZQlk25Gken1Ba2m0l50UEXEdQKIZ93Bb8L2FV4tzU=";
    })
    (fetchFromGitHub {
      name = "PPQSort";
      owner = "GabTux";
      repo = "PPQSort";
      rev = "v1.0.6";
      hash = "sha256-HgM+p2QGd9C8A8l/VaEB+cLFDrY2HU6mmXyTNh7xd0A=";
    })
    # Transitive from PPQSort
    (fetchFromGitHub {
      name = "PackageProject.cmake";
      owner = "TheLartians";
      repo = "PackageProject.cmake";
      rev = "v1.11.1";
      hash = "sha256-E7WZSYDlss5bidbiWL1uX41Oh6JxBRtfhYsFU19kzIw=";
    })
    (fetchFromGitHub {
      name = "capstone";
      owner = "capstone-engine";
      repo = "capstone";
      rev = "6.0.0-Alpha11";
      hash = "sha256-ShiRgCDhzJB3/t/jeiWWa1IQgj254S7/8MGXjD+TUiM=";
    })
    (fetchFromGitHub {
      name = "base64";
      owner = "aklomp";
      repo = "base64";
      rev = "v0.5.2";
      hash = "sha256-dIaNfQ/znpAdg0/vhVNTfoaG7c8eFrdDTI0QDHcghXU=";
    })
    (fetchFromGitHub {
      name = "usearch";
      owner = "unum-cloud";
      repo = "usearch";
      rev = "v2.26.4";
      fetchSubmodules = true;
      hash = "sha256-yKVe/LktTLxRvMHGKHw9Qr2EhYTlw440AT0rehUl9zU=";
    })
  ];
}
