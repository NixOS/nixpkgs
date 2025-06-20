{
  lib,
  fetchFromGitHub,
  fetchurl,
  fetchFromGitLab,
  runCommand,
}:
let
  # List of all the dependencies that get fetched via CPM during the configure phase
  # This was obtained by repeatedly running `nix build` and looking for
  # messages like these in the logs:
  # CPM: Adding package zstd@1.5.7 (v1.5.7 to /build/source/cpm_source_cache/zstd/dfd2e0b6e613dcf44911302708e636a8aee527d2)
  #
  # The weird hash seems to be a sha1 of the arguments passed to CPMAddPackage and is calculated in /tracy/cmake/CPM.cmake:782
  # I don't think it's feasible to calculate that ourselves, so lets just use the one that CPM tells us it wants (see above).
  #
  # If we pass git into nativeBuildDependencies and disable the no git patch, then the build logs also tell us
  # the repository that CPM tries to download the sources from
  cpmDeps = [
    {
      name = "zstd";
      cpmHash = "dfd2e0b6e613dcf44911302708e636a8aee527d2";
      src = fetchFromGitHub {
        owner = "facebook";
        repo = "zstd";
        rev = "v1.5.7";
        hash = "sha256-tNFWIT9ydfozB8dWcmTMuZLCQmQudTFJIkSr0aG7S44=";
      };
    }
    {
      name = "imgui";
      cpmHash = "f37d9e60facb8be35b723894c4328b647b528acc";
      src = fetchFromGitHub {
        owner = "ocornut";
        repo = "imgui";
        rev = "v1.91.9b-docking";
        hash = "sha256-mQOJ6jCN+7VopgZ61yzaCnt4R1QLrW7+47xxMhFRHLQ=";
      };
    }
    {
      cpmHash = "bf32a9c270fd365188dde100072895f33a4a80ea";
      name = "nfd";
      src = fetchFromGitHub {
        owner = "btzy";
        repo = "nativefiledialog-extended";
        rev = "v1.2.1";
        hash = "sha256-GwT42lMZAAKSJpUJE6MYOpSLKUD5o9nSe9lcsoeXgJY=";
      };
    }
    {
      name = "ppqsort";
      cpmHash = "4edf0b4c8b76ee125cf773da2d6721859de2bcb6";
      src = fetchFromGitHub {
        owner = "GabTux";
        repo = "PPQSort";
        rev = "v1.0.5";
        hash = "sha256-EMZVI/uyzwX5637/rdZuMZoql5FTrsx0ESJMdLVDmfk=";
      };
    }
    {
      cpmHash = "c68db851083fcffa27a786090cedcce4c4f28330";
      name = "capstone";
      src = fetchFromGitHub {
        owner = "capstone-engine";
        repo = "capstone";
        rev = "6.0.0-Alpha1";
        hash = "sha256-oKRu3P1inWueEMIpL0uI2ayCMHZ9FIVotil4sqwLqH4=";
      };
    }
    {
      cpmHash = "39dc740304285c2e0815cb4669f337dc2af3b0a3";
      name = "packageproject.cmake";
      # Transitive from PPQSort
      src = fetchFromGitHub {
        owner = "TheLartians";
        repo = "PackageProject.cmake";
        rev = "v1.11.1";
        hash = "sha256-E7WZSYDlss5bidbiWL1uX41Oh6JxBRtfhYsFU19kzIw=";
      };
    }
    {
      name = "wayland-protocols";
      cpmHash = "3a610bd6f6d8d4694c16e24bcd207d5976e1bb58";
      src = fetchFromGitLab {
        owner = "wayland";
        repo = "wayland-protocols";
        rev = "1.37";
        domain = "gitlab.freedesktop.org";
        hash = "sha256-ryyv1RZqpwev1UoXRlV8P1ujJUz4m3sR89iEPaLYSZ4=";
      };
    }
  ];

  # Weird CPM Dep where ppqsort uses cpm to manage cpm itself
  cpmDep = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.38.7/CPM.cmake";
    hash = "sha256-g+XrcbK7uLHyrTjxlQKHoFdiTjhcI49gh/lM38RK+cU=";
  };
  # Combine all the dependencies into the cpm source cache, that gets copied into the build directory
in
runCommand "cpm-source-cache" { } (
  ''
    mkdir -p $out/cpm
    cp --no-preserve=mode -r ${cpmDep} $out/cpm/CPM_0.38.7.cmake
  ''
  + (lib.strings.concatMapStringsSep "\n" (dep: ''
    mkdir -p $out/${dep.name}/${dep.cpmHash}
    cp --no-preserve=mode -r ${dep.src}/. $out/${dep.name}/${dep.cpmHash}
  '') cpmDeps)
)
