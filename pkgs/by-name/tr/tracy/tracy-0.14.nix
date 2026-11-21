{
  fetchFromGitHub,

  pugixml,
  curl,
  zstd,
  nlohmann_json,
  html-tidy,
}:
{
  version = "0.14.1";
  srcHash = "sha256-vcLI9jb7eYcR162LgBQ2P4A0oiZuYRfYRQiDhlAk5TI=";
  extraBuildInputs = [
    pugixml
    curl
    zstd
    nlohmann_json
    html-tidy
  ];
  cpmSrcs = [
    (fetchFromGitHub {
      name = "ImGui";
      owner = "ocornut";
      repo = "imgui";
      rev = "v1.92.9b-docking";
      hash = "sha256-PknWLxYuXQ73TCFN+eKOJDNLGbg/ZqKSF6mFxkJG6vI=";
    })
    (fetchFromGitHub {
      name = "nfd";
      owner = "btzy";
      repo = "nativefiledialog-extended";
      rev = "3cd252a8f7ca32419b1ca235c2990ba6a0ecba7c";
      fetchSubmodules = true;
      hash = "sha256-BV4FdH+AfNXAbLfipBPMGkJmggo59Kf4NIgKQ0hsB9g=";
    })
    (fetchFromGitHub {
      name = "md4c";
      owner = "mity";
      repo = "md4c";
      rev = "65c6c9d72cebd9a731aaa5597414ce04d9ea5de3";
      hash = "sha256-UMIebye8pQkiTjhbz3btTqPapzoqOnPHrtbPitc717A=";
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
      rev = "6.0.0-Alpha5";
      hash = "sha256-18PTj4hvBw8RTgzaFGeaDbBfkxmotxSoGtprIjcEuVg=";
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
      rev = "v2.26.0";
      fetchSubmodules = true;
      hash = "sha256-FsU/e8Aq+ARWV94c8MNJPL/edkde1Lj0cA3dOVrrm/0=";
    })
  ];
}
