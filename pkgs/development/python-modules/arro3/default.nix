{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  geoarrow-types,
  pyarrow,
  numpy,
  pandas,
}:
let
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "kylebarron";
    repo = "arro3";
    tag = "py-v${version}";
    hash = "sha256-RTr+mf5slfxxvXp9cwPuy08AZUswPtIIRz+vngdg/k0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit version src;
    pname = "arro3-vendor";
    hash = "sha256-YQA8Z86Ul8yAHncMgYrGmNe10KSpubHjaokCjaqTAxo=";
  };

  commonMeta = {
    homepage = "https://github.com/kylebarron/arro3";
    changelog = "https://github.com/kylebarron/arro3/releases/tag/py-v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mslingsby ];
  };

  buildArro3Package =
    {
      pname,
      subdir,
      description,
      pythonImportsCheck,
      dependencies ? [ ],
    }:
    buildPythonPackage rec {
      inherit
        pname
        version
        src
        cargoDeps
        dependencies
        pythonImportsCheck
        ;
      pyproject = true;

      sourceRoot = "${src.name}/${subdir}";
      cargoRoot = "..";

      nativeBuildInputs = with rustPlatform; [
        cargoSetupHook
        maturinBuildHook
      ];

      env = {
        CARGO_TARGET_DIR = "./target";
      };

      # Avoid infinite recursion in tests.
      # arro3-core tests depends on arro3-compute and arro3-compute depends on arro3-core
      passthru.tests = { inherit arro3-tests; };

      meta = commonMeta // {
        inherit description;
      };
    };

  arro3-core = buildArro3Package {
    pname = "arro3-core";
    subdir = "arro3-core";
    description = "Core library for representing Arrow data in Python";
    pythonImportsCheck = [ "arro3.core" ];
  };

  arro3-compute = buildArro3Package {
    pname = "arro3-compute";
    subdir = "arro3-compute";
    description = "Rust-based compute kernels for Arrow in Python";
    pythonImportsCheck = [ "arro3.compute" ];
    dependencies = [ arro3-core ];
  };

  arro3-io = buildArro3Package {
    pname = "arro3-io";
    subdir = "arro3-io";
    description = "Rust-based readers and writers for Arrow in Python";
    pythonImportsCheck = [ "arro3.io" ];
    dependencies = [ arro3-core ];
  };

  arro3-tests = buildPythonPackage {
    pname = "arro3-tests";
    version = arro3-core.version;

    format = "other";
    dontBuild = true;
    dontInstall = true;

    inherit src;

    nativeCheckInputs = [
      pytestCheckHook
      geoarrow-types
      pandas
      pyarrow
      numpy
      arro3-core
      arro3-compute
      arro3-io
    ];
  };
in
{
  inherit arro3-core arro3-io arro3-compute;
}
