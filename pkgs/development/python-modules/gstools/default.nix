{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  hatch-vcs,
  hatchling,

  # dependencies
  emcee,
  gstools-cython,
  hankel,
  meshio,
  numpy,
  pyevtk,
  scipy,

  # optional dependencies
  matplotlib,
  pyvista,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "gstools";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GeoStat-Framework";
    repo = "GSTools";
    tag = "v${version}";
    hash = "sha256-rQ7mSa1BWAaRiiE6aQD6jl8BktihY9bjFJV+5eT9n/M=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    emcee
    gstools-cython
    hankel
    meshio
    numpy
    pyevtk
    scipy
  ];

  optional-dependencies = {
    plotting = [
      matplotlib
      pyvista
    ];
  };

  pythonImportsCheck = [ "gstools" ];
  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  meta = {
    description = "Geostatistical toolbox";
    homepage = "https://github.com/GeoStat-Framework/GSTools";
    changelog = "https://github.com/GeoStat-Framework/GSTools/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
