{
  lib,
  buildPythonPackage,
  flax,
  tomlq,
  python,

  # build-system
  nanobind,
  ninja,
  scikit-build-core,

  # nativeBuildInputs
  cmake,
  pkg-config,
}:

buildPythonPackage rec {
  pname = "flaxlib";
  version = "0.0.1";
  pyproject = true;

  inherit (flax) src;

  sourceRoot = "${src.name}/flaxlib_src";

  postPatch = ''
    expected_version="$version"
    actual_version=$(${lib.getExe tomlq} --raw --file pyproject.toml "project.version")

    if [ "$actual_version" != "$expected_version" ]; then
      echo -e "\n\tERROR:"
      echo -e "\tThe version of the flaxlib python package ($expected_version) does not match the one in its pyproject.toml file ($actual_version)"
      echo -e "\tPlease update the version attribute of the nix python3Packages.flaxlib package."
      exit 1
    fi
  '';

  dontUseCmakeConfigure = true;

  build-system = [
    nanobind
    ninja
    scikit-build-core
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  env.CMAKE_PREFIX_PATH = "${nanobind}/${python.sitePackages}/nanobind";

  pythonImportsCheck = [ "flaxlib" ];

  # This package does not have tests (yet ?)
  doCheck = false;

  passthru = {
    inherit (flax) updateScript;
  };

  meta = {
    description = "Rust library used internally by flax";
    homepage = "https://github.com/google/flax/tree/main/flaxlib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
