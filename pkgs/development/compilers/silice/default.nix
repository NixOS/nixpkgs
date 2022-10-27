{ stdenv, fetchFromGitHub, lib
, cmake, pkg-config, openjdk
, libuuid, python3
, silice, yosys, nextpnr, verilator
, dfu-util, icestorm, trellis
}:

stdenv.mkDerivation rec {
  pname = "silice";
  version = "unstable-2022-08-05";

  src = fetchFromGitHub {
    owner = "sylefeb";
    repo = pname;
    rev = "e26662ac757151e5dd8c60c45291b44906b1299f";
    sha256 = "sha256-Q1JdgDlEErutZh0OfxYy5C4aVijFKlf6Hm5Iv+1jsj4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    openjdk
  ];
  buildInputs = [
    libuuid
  ];
  propagatedBuildInputs = [
    (python3.withPackages (p: with p; [ edalize ]))
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

  meta = with lib; {
    description = "Open source language that simplifies prototyping and writing algorithms on FPGA architectures";
    homepage = "https://github.com/sylefeb/Silice";
    license = licenses.bsd2;
    maintainers = [ maintainers.astro ];
  };
}
