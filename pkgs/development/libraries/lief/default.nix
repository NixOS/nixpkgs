{ lib
, stdenv
, fetchFromGitHub
, python
, cmake
}:

let
  pyEnv = python.withPackages (ps: [ ps.setuptools ]);
in
stdenv.mkDerivation rec {
  pname = "lief";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "lief-project";
    repo = "LIEF";
    rev = version;
    sha256 = "sha256-wZgv4AFc7DrMCyxMLKQxO1mUTDAU4klK8aZAySqGJoY=";
  };

  outputs = [ "out" "py" ];

  nativeBuildInputs = [
    cmake
  ];

  # Not a propagatedBuildInput because only the $py output needs it; $out is
  # just the library itself (e.g. C/C++ headers).
  buildInputs = [
    python
  ];

  dontUseCmakeConfigure = true;

  buildPhase = ''
    runHook preBuild

    substituteInPlace setup.py \
      --replace 'cmake_args = []' "cmake_args = [ \"-DCMAKE_INSTALL_PREFIX=$prefix\" ]"
    ${pyEnv.interpreter} setup.py --sdk build --parallel=$NIX_BUILD_CORES

    runHook postBuild
  '';

  # I was unable to find a way to build the library itself and have it install
  # to $out, while also installing the Python bindings to $py without building
  # the project twice (using cmake), so this is the best we've got. It uses
  # something called CPack to create the tarball, but it's not obvious to me
  # *how* that happens, or how to intercept it to just get the structured
  # library output.
  installPhase = ''
    runHook preInstall

    mkdir -p $out $py/nix-support
    echo "${python}" >> $py/nix-support/propagated-build-inputs
    tar xf build/*.tar.gz --directory $out --strip-components 1
    ${pyEnv.interpreter} setup.py install --skip-build --root=/ --prefix=$py

    runHook postInstall
  '';

  meta = with lib; {
    description = "Library to Instrument Executable Formats";
    homepage = "https://lief.quarkslab.com/";
    license = [ licenses.asl20 ];
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.lassulus ];
  };
}
