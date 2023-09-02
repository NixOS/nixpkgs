{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, setuptools
, setuptools-scm
, numpy
, pybind11
, wheel
, pytestCheckHook
, pythonOlder
, graphviz
}:

buildPythonPackage rec {
  pname = "pyhepmc";
  version = "2.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-po1ad02dpY69RRhaRApskH6tdOaSIsCl5PgpjsAzyKo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    setuptools
    setuptools-scm
    wheel
  ];

  buildInputs = [
    pybind11
  ];

  propagatedBuildInputs = [
    numpy
  ];

  dontUseCmakeConfigure = true;

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
  CMAKE_ARGS = [ "-DEXTERNAL_PYBIND11=ON" ];

  preBuild = ''
    export CMAKE_BUILD_PARALLEL_LEVEL="$NIX_BUILD_CORES"
  '';

  nativeCheckInputs = [
    graphviz
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyhepmc" ];

  meta = with lib; {
    description = "Easy-to-use Python bindings for HepMC3";
    homepage = "https://github.com/scikit-hep/pyhepmc";
    changelog = "https://github.com/scikit-hep/pyhepmc/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}

