{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  cmake,
  ninja,
}:

let
  pyEnv = python3.withPackages (ps: [
    ps.setuptools
    ps.tomli
    ps.pip
    ps.setuptools
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lief";
  version = "0.16.6";

  src = fetchFromGitHub {
    owner = "lief-project";
    repo = "LIEF";
    tag = finalAttrs.version;
    hash = "sha256-SvwFyhIBuG0u5rE7+1OaO7VZu4/X4jVI6oFOm5+yCd8=";
  };

  outputs = [
    "out"
    "py"
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  # Not in propagatedBuildInputs because only the $py output needs it; $out is
  # just the library itself (e.g. C/C++ headers).
  buildInputs = with python3.pkgs; [
    python
    build
    pathspec
    pip
    pydantic
    scikit-build-core
  ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic)) ];

  postBuild = ''
    pushd ../api/python
    ${pyEnv.interpreter} -m build --no-isolation --wheel --skip-dependency-check --config-setting=--parallel=$NIX_BUILD_CORES
    popd
  '';

  postInstall = ''
    pushd ../api/python
    ${pyEnv.interpreter} -m pip install --prefix $py dist/*.whl
    popd
  '';

  meta = with lib; {
    description = "Library to Instrument Executable Formats";
    homepage = "https://lief.quarkslab.com/";
    license = [ licenses.asl20 ];
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [
      lassulus
      genericnerdyusername
    ];
  };
})
