{
  stdenv,
  lib,
  fetchFromGitHub,
  libtool,
  automake,
  autoconf,
  ucx,
  config,
  enableCuda ? config.cudaSupport,
  cudaPackages,
  enableAvx ? stdenv.hostPlatform.avxSupport,
  enableSse41 ? stdenv.hostPlatform.sse4_1Support,
  enableSse42 ? stdenv.hostPlatform.sse4_2Support,
}:

stdenv.mkDerivation rec {
  pname = "ucc";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucc";
    rev = "v${version}";
    sha256 = "sha256-xcJLYktkxNK2ewWRgm8zH/dMaIoI+9JexuswXi7MpAU=";
  };

  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  postPatch = ''

    for comp in $(find src/components -name Makefile.am); do
      substituteInPlace $comp \
        --replace "/bin/bash" "${stdenv.shell}"
    done
  '';

  nativeBuildInputs = [
    libtool
    automake
    autoconf
  ] ++ lib.optionals enableCuda [ cudaPackages.cuda_nvcc ];
  buildInputs =
    [ ucx ]
    ++ lib.optionals enableCuda [
      cudaPackages.cuda_cccl
      cudaPackages.cuda_cudart
    ];

  preConfigure =
    ''
      ./autogen.sh
    ''
    + lib.optionalString enableCuda ''
      configureFlagsArray+=( "--with-nvcc-gencode=${builtins.concatStringsSep " " cudaPackages.cudaFlags.gencode}" )
    '';
  configureFlags =
    [ ]
    ++ lib.optional enableSse41 "--with-sse41"
    ++ lib.optional enableSse42 "--with-sse42"
    ++ lib.optional enableAvx "--with-avx"
    ++ lib.optional enableCuda "--with-cuda=${cudaPackages.cuda_cudart}";

  postInstall = ''
    find $out/lib/ -name "*.la" -exec rm -f \{} \;

    moveToOutput bin/ucc_info $dev
  '';

  meta = with lib; {
    description = "Collective communication operations API";
    mainProgram = "ucc_info";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
