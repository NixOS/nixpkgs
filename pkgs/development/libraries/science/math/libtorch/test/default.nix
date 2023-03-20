{ lib
, stdenv
, cmake
, libtorch-bin
, linkFarm
, symlinkJoin

, cudaSupport
, cudaPackages ? {}
}:
let
  inherit (cudaPackages) cudatoolkit cudnn;

  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    paths = [ cudatoolkit.out cudatoolkit.lib ];
  };

  # We do not have access to /run/opengl-driver/lib in the sandbox,
  # so use a stub instead.
  cudaStub = linkFarm "cuda-stub" [{
    name = "libcuda.so.1";
    path = "${cudatoolkit}/lib/stubs/libcuda.so";
  }];

in stdenv.mkDerivation {
  pname = "libtorch-test";
  version = libtorch-bin.version;

  src = ./.;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libtorch-bin ] ++
    lib.optionals cudaSupport [ cudnn ];

  cmakeFlags = lib.optionals cudaSupport
    [ "-DCUDA_TOOLKIT_ROOT_DIR=${cudatoolkit_joined}" ];

  doCheck = true;

  installPhase = ''
    touch $out
  '';

  checkPhase = lib.optionalString cudaSupport ''
    LD_LIBRARY_PATH=${cudaStub}''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH \
  '' + ''
    ./test
  '';
}
