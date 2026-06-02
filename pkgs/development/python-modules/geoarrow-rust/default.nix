{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  arro3-core,
  pyarrow,
  pyproj,
  numpy,
  pandas,
  geoarrow-types,
}:
let
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "geoarrow";
    repo = "geoarrow-rs";
    tag = "py-v${version}";
    hash = "sha256-3/HOQsgQVpEd9iAVvIHvpb0slg55/V6X6KLLvhDUVz4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src version;
    pname = "geoarrow-rust-vendor";
    cargoRoot = "python";
    hash = "sha256-UjLqynlt5Rkx10hlnaY76wDRhJwhNvHmkhpj04Y8/ek=";
  };

  commonMeta = {
    homepage = "https://github.com/geoarrow/geoarrow-rs";
    changelog = "https://github.com/geoarrow/geoarrow-rs/releases/tag/py-v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ daspk04 ];
  };

  buildGeoArrowPackage =
    {
      pname,
      subdir,
      description,
      pythonImportsCheck,
      dependencies ? [ ],
    }:
    buildPythonPackage {
      inherit
        pname
        version
        src
        cargoDeps
        dependencies
        pythonImportsCheck
        ;
      pyproject = true;

      sourceRoot = "${src.name}/python/${subdir}";
      cargoRoot = "..";
      __structuredAttrs = true;

      nativeBuildInputs = with rustPlatform; [
        cargoSetupHook
        maturinBuildHook
      ];

      postPatch = ''
        chmod -R +w ../..
      '';

      # set target directory so maturin can find the compiled libraries in this workspace setup
      env = {
        CARGO_TARGET_DIR = "./target";
      };

      passthru.tests = { inherit geoarrow-rust-tests; };

      meta = commonMeta // {
        inherit description;
      };
    };

  geoarrow-rust-core = buildGeoArrowPackage {
    pname = "geoarrow-rust-core";
    subdir = "geoarrow-core";
    description = "Core library for representing GeoArrow data in Python";
    pythonImportsCheck = [ "geoarrow.rust.core" ];
    dependencies = [
      arro3-core
      pyproj
    ];
  };

  geoarrow-rust-io = buildGeoArrowPackage {
    pname = "geoarrow-rust-io";
    subdir = "geoarrow-io";
    description = "Rust-based readers and writers for GeoArrow in Python";
    pythonImportsCheck = [ "geoarrow.rust.io" ];
    dependencies = [
      arro3-core
      pyproj
    ];
  };

  geoarrow-rust-tests = buildPythonPackage {
    pname = "geoarrow-rust-tests";
    inherit src version;

    pyproject = false;
    dontBuild = true;
    dontInstall = true;

    nativeCheckInputs = [
      pytestCheckHook
      geoarrow-types
      pandas
      pyarrow
      numpy
      geoarrow-rust-core
      geoarrow-rust-io
    ];

    pytestFlags = [ "python" ];
  };
in
{
  inherit geoarrow-rust-core geoarrow-rust-io;
}
