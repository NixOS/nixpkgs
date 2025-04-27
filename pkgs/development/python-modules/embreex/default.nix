{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  embree2,
  cython,
  numpy,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "embreex";
  version = "2.17.7.post6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trimesh";
    repo = "embreex";
    tag = version;
    hash = "sha256-iLIfhngorSFOdkOvlCAJQXGQrVuRfBSDGzvjXOlQuHk=";
  };

  patches = [
    # https://github.com/trimesh/embreex/pull/7
    (fetchpatch {
      name = "fix-use-after-free.patch";
      url = "https://github.com/trimesh/embreex/commit/c6b047285419f8986fae962e2734a01522be7ef7.patch";
      hash = "sha256-s8x2vsqbsIR3aoNUDrYs2vQttuNY8lLJ6TC7H8FMRyQ=";
    })
  ];

  build-system = [
    setuptools
    numpy
    cython
  ];

  dependencies = [
    numpy
  ];

  buildInputs = [
    embree2
    embree2.tbb
  ];

  pythonImportsCheck = [
    "embreex"
    "embreex.mesh_construction"
    "embreex.rtcore"
    "embreex.rtcore_scene"
    "embreex.triangles"
  ];

  preCheck = ''
    # conflicts with $out
    rm -rf embreex/
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Maintained PyEmbree fork, wrapper for Embree v2";
    homepage = "https://github.com/trimesh/embreex";
    changelog = "https://github.com/trimesh/embreex/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pbsds ];
    inherit (embree2.meta) platforms;
  };
}
