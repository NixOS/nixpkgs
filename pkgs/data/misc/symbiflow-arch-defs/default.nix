{ stdenv
, fetchurl
, autoPatchelfHook
, python3Packages
, archs ? [ "xc7a100t" "xc7a50t" "xc7z010" "xc7z020" ]
}:

stdenv.mkDerivation rec {
  pname   = "symbiflow-arch-defs";
  version = "20200914-111752-g05d68df0";

  src = fetchurl {
    url = "https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/66/20200914-111752/symbiflow-arch-defs-install-05d68df0.tar.xz";
    sha256 = "1gmynybh8n33ag521w17c2kd16n834hqc6d8hi2pfs5kg1jl1a74";
  };

  sourceRoot = ".";

  propagatedBuildInputs = [
    python3Packages.lxml
    python3Packages.python-constraint
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r bin/{symbiflow_*,vpr_common,python} $out/bin
    for script in $out/bin/symbiflow_*; do
        substituteInPlace $script --replace '/env' '/symbiflow_env'
    done
    cp bin/env $out/bin/symbiflow_env

    mkdir -p $out/share/symbiflow/arch
    cp -r share/symbiflow/{scripts,techmaps} $out/share/symbiflow/

    for arch in ${builtins.concatStringsSep " " archs}; do
        cp -r share/symbiflow/arch/"$arch"_test* $out/share/symbiflow/arch/
    done
  '';

  meta = with stdenv.lib; {
    description = "Project X-Ray - Xilinx Series 7 Bitstream Documentation";
    homepage    = "https://github.com/SymbiFlow/symbiflow-arch-defs";
    hydraPlatforms = [];
    license     = licenses.isc;
    platforms   = platforms.all;
  };
}
