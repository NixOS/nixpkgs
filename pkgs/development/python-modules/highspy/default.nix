{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  pythonOlder,
  scikit-build-core,
  pybind11,
  numpy,
  cmake,
  ninja,
  pathspec,
}:
buildPythonPackage rec {
  pname = "highspy";
  version = "1.7.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ERGO-Code";
    repo = "HiGHS";
    rev = "refs/tags/v${version}";
    hash = "sha256-q18TfKbZyTZzzPZ8z3U57Yt8q2PSvbkg3qqqiPMgy5Q=";
  };

  build-system = [
    cmake
    ninja
    pathspec
    scikit-build-core
    pybind11
  ];

  dontUseCmakeConfigure = true;

  dependencies = [ numpy ];

  pythonImportsCheck = [ "highspy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Linear optimization software";
    homepage = "https://github.com/ERGO-Code/HiGHS";
    license = licenses.mit;
    maintainers = with maintainers; [ renesat ];
  };
}
