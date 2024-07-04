{ stdenv, fetchFromGitHub, lib
, cmake, pkg-config, openjdk
, libuuid, python3
, glfw
, silice, yosys, nextpnr, verilator
, dfu-util, icestorm, trellis
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "silice";
  version = "0-unstable-2024-06-23";

  src = fetchFromGitHub {
    owner = "sylefeb";
    repo = pname;
    rev = "5ba9ef0d03b3c8d4a43efe10acfb51c97d3679ef";
    sha256 = "sha256-LrLUaCpwzaxH02TGyEfARIumPi0s2REc1g79fSxJjFc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    openjdk
    glfw
  ];
  buildInputs = [
    libuuid
  ];
  propagatedBuildInputs = [
    (python3.withPackages (p: [
      p.edalize
      p.termcolor
    ]))
  ];

  postPatch = ''
    patchShebangs antlr/antlr.sh
    # use nixpkgs version
    rm -r python/pybind11
  '';

  installPhase = ''
    make install
    mkdir -p $out
    cp -ar ../{bin,frameworks,lib} $out/
  '';

  passthru.tests =
    let
      testProject = project: stdenv.mkDerivation {
        name = "${silice.name}-test-${project}";
        nativeBuildInputs = [
          silice
          yosys
          nextpnr
          verilator
          dfu-util
          icestorm
          trellis
        ];
        src = "${src}/projects";
        sourceRoot = "projects/${project}";
        buildPhase = ''
          targets=$(cut -d " " -f 2 configs | tr -d '\r')
          for target in $targets ; do
            make $target ARGS="--no_program"
          done
        '';
        installPhase = ''
          mkdir $out
          for target in $targets ; do
            cp -r BUILD_$target $out/
          done
        '';
      };
    in {
      # a selection of test projects that build with the FPGA tools in
      # nixpkgs
      audio_sdcard_streamer = testProject "audio_sdcard_streamer";
      bram_interface = testProject "bram_interface";
      blinky = testProject "blinky";
      pipeline_sort = testProject "pipeline_sort";
    };

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Open source language that simplifies prototyping and writing algorithms on FPGA architectures";
    homepage = "https://github.com/sylefeb/Silice";
    license = licenses.bsd2;
    maintainers = [ maintainers.astro ];
  };
}
