{
  lib,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  joblib,
  matplotlib,
  ninja,
  numpy,
  pandas,
  pathspec,
  pyproject-metadata,
  pybind11,
  pytestCheckHook,
  pythonOlder,
  scikit-build-core,
  scipy,
}:

buildPythonPackage rec {
  pname = "phik";
  version = "0.12.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "KaveIO";
    repo = "PhiK";
    rev = "refs/tags/v${version}";
    hash = "sha256-YsH7vVn6gzejunUjUY/RIcvWtaQ/W1gbciJWKi5LDTk=";
  };

  build-system = [
    cmake
    ninja
    pathspec
    pybind11
    pyproject-metadata
    scikit-build-core
  ];

  dependencies = [
    joblib
    matplotlib
    numpy
    pandas
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Uses scikit-build-core to drive build process
  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "phik" ];

  preCheck = ''
    # import from $out
    rm -r phik
  '';

  meta = with lib; {
    description = "Phi_K correlation analyzer library";
    longDescription = ''
      Phi_K is a new and practical correlation coefficient based on several refinements to
      Pearson’s hypothesis test of independence of two variables.
    '';
    homepage = "https://phik.readthedocs.io/";
    changelog = "https://github.com/KaveIO/PhiK/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ melsigl ];
  };
}
