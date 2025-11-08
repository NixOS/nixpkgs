{
  lib,
  buildPythonPackage,
  blessed,
  fetchFromGitHub,
  invoke,
  pythonOlder,
  releases,
  semantic-version,
  tabulate,
  tqdm,
  twine,
  pytestCheckHook,
  pytest-relaxed,
  pytest-mock,
  icecream,
  pip,
}:

buildPythonPackage rec {
  pname = "invocations";
  version = "3.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pyinvoke";
    repo = "invocations";
    tag = version;
    hash = "sha256-JnhdcxhBNsYgDMcljtGKjOT1agujlao/66QifGuh6I0=";
  };

  patches = [ ./replace-blessings-with-blessed.patch ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "semantic_version>=2.4,<2.7" "semantic_version"
  '';

  propagatedBuildInputs = [
    blessed
    invoke
    releases
    semantic-version
    tabulate
    tqdm
    twine
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-relaxed
    pytest-mock
    icecream
    pip
  ];

  pythonImportsCheck = [ "invocations" ];

  disabledTests = [
    # invoke.exceptions.UnexpectedExit
    "autodoc_"

    # ValueError: Call either Version('1.2.3') or Version(major=1, ...)
    "component_state_enums_contain_human_readable_values"
    "load_version_"
    "prepare_"
    "status_"
  ];

  meta = with lib; {
    description = "Common/best-practice Invoke tasks and collections";
    homepage = "https://invocations.readthedocs.io/";
    changelog = "https://github.com/pyinvoke/invocations/blob/${version}/docs/changelog.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ samuela ];
  };
}
