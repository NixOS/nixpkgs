{ stdenv, fetchurl, autoPatchelfHook, rpmextract, rocm-runtime }:

stdenv.mkDerivation rec {
  pname = "rocm-runtime-ext";
  version = "3.5.1";

  src = fetchurl {
    url = "https://repo.radeon.com/rocm/yum/3.5.1/hsa-ext-rocr-dev-1.1.30501.0-rocm-rel-3.5-34-def83d8a-Linux.rpm";
    sha256 = "0r7lrmnplr10hs6wrji55i3dnczfzlmp8jahm1g3mhq2x12zmly0";
  };

  nativeBuildInputs = [ autoPatchelfHook rpmextract ];

  buildInputs = [ rocm-runtime stdenv.cc.cc ];

  unpackPhase = "rpmextract ${src}";

  installPhase = ''
    mkdir -p $out/lib
    cp -R opt/rocm-${version}/hsa/lib $out/lib/rocm-runtime-ext
  '';

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "Platform runtime for ROCm (closed-source extensions)";
    longDescription = ''
      This package provides closed-source extensions to the ROCm
      runtime. Currently this adds support for OpenCL image
      processing.

      In order for the ROCm runtime to pick up the extension, you
      should either set the ROCR_EXT_DIR environment variable should
      be set to ''${rocm-runtime-ext}/lib/rocm-runtime-ext or this
      package should be added to the hardware.opengl.extraPackages
      NixOS configuration option.
    '';
    homepage = "https://github.com/RadeonOpenCompute/ROCR-Runtime";
    license = with licenses; [ unfreeRedistributable ];
    maintainers = with maintainers; [ danieldk ];
  };
}
