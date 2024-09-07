{
  lib,
  buildPythonPackage,
  callPackage,
  faiss-build,
  numpy,
  packaging,
  setuptools,
  pip,
  wheel,
}:

buildPythonPackage {
  inherit (faiss-build) pname version;
  pyproject = true;

  src = "${lib.getOutput "dist" faiss-build}";

  postPatch = ''
    mkdir dist
    mv *.whl dist/
  '';

  build-system = [
    setuptools
    pip
    wheel
  ];

  dependencies = [
    numpy
    packaging
  ];

  # E.g. cuda libraries; needed because reference scanning
  # can't see inside the wheels
  inherit (faiss-build) buildInputs;

  dontBuild = true;

  pythonImportsCheck = [ "faiss" ];

  passthru = {
    inherit (faiss-build) cudaSupport cudaPackages pythonSupport;

    tests = {
      pytest = callPackage ./pytest.nix { inherit faiss-build; };
    };
  };

  meta = lib.pipe (faiss-build.meta or { }) [
    (lib.flip builtins.removeAttrs [ "mainProgram" ])
    (m: m // { description = "Bindings for faiss, the similarity search library"; })
  ];
}
