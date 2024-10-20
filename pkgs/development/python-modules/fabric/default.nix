{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
  decorator,
  invoke,
  mock,
  paramiko,
  pynacl,
  pypaInstallHook,
  pytest-relaxed,
  pytestCheckHook,
  setuptoolsBuildHook,
}:

buildPythonPackage rec {
  pname = "fabric";
  version = "3.2.2";
  pyproject = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h4PKQuOwB28IsmkBqsa52bHxnEEAdOesz6uQLBhP9KM=";
  };

  # only relevant to python < 3.4
  postPatch = ''
    substituteInPlace setup.py \
        --replace ', "pathlib2"' ' '
  '';

  nativeBuildInputs = [
    pypaInstallHook
    setuptoolsBuildHook
  ];

  dependencies = [
    cryptography
    decorator
    invoke
    paramiko
    pynacl
  ];

  nativeCheckInputs = [
    mock
    pytest-relaxed
    pytestCheckHook
  ];

  # ==================================== ERRORS ====================================
  # ________________________ ERROR collecting test session _________________________
  # Direct construction of SpecModule has been deprecated, please use SpecModule.from_parent
  # See https://docs.pytest.org/en/stable/deprecations.html#node-construction-changed-to-node-from-parent for more details.
  doCheck = false;

  pythonImportsCheck = [ "fabric" ];

  meta = {
    description = "Pythonic remote execution";
    homepage = "http://fabfile.org/";
    changelog = "https://www.fabfile.org/changelog.html";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "fab";
  };
}
