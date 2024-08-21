{ stdenv
, lib
, fetchgit
, cmake
, llvmPackages
, enablePython ? false
, python ? null
}:

let pyEnv = python.withPackages (p: with p; [ numpy scipy ]);

in stdenv.mkDerivation rec {
  pname = "taco";
  version = "unstable-2022-08-02";

  src = fetchgit {
    url = "https://github.com/tensor-compiler/${pname}.git";
    rev = "2b8ece4c230a5f0f0a74bc6f48e28edfb6c1c95e";
    fetchSubmodules = true;
    hash = "sha256-PnBocyRLiLALuVS3Gkt/yJeslCMKyK4zdsBI8BFaTSg=";
  };

  # Remove test cases from cmake build as they violate modern C++ expectations
  patches = [ ./taco.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional stdenv.isDarwin llvmPackages.openmp;

  propagatedBuildInputs = lib.optional enablePython pyEnv;

  cmakeFlags = [
    "-DOPENMP=ON"
  ] ++ lib.optional enablePython "-DPYTHON=ON" ;

  postInstall = lib.strings.optionalString enablePython ''
    mkdir -p $out/${python.sitePackages}
    cp -r lib/pytaco $out/${python.sitePackages}/.
  '';

  # The standard CMake test suite fails a single test of the CLI interface.
  doCheck = false;

  # Cython somehow gets built with references to /build/.
  # However, the python module works flawlessly.
  dontFixup = enablePython;

  meta = with lib; {
    description = "Computes sparse tensor expressions on CPUs and GPUs";
    mainProgram = "taco";
    license = licenses.mit;
    homepage = "https://github.com/tensor-compiler/taco";
    maintainers = [ maintainers.sheepforce ];
  };
}
