{
  lib,
  buildPythonPackage,
  blessed,
  fetchFromGitHub,
  invoke,
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
  version = "4.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pyinvoke";
    repo = "invocations";
    tag = version;
    hash = "sha256-G6EKypqP2/coPChLwwEKZ2WIEay0qfyM8M5jKb0oS2c=";
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

  meta = {
    description = "Common/best-practice Invoke tasks and collections";
    homepage = "https://invocations.readthedocs.io/";
    changelog = "https://github.com/pyinvoke/invocations/blob/${src.tag}/docs/changelog.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
