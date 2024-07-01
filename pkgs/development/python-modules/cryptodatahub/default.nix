{
  lib,
  asn1crypto,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitLab,
  pathlib2,
  pyfakefs,
  python-dateutil,
  pythonOlder,
  setuptools,
  six,
  unittestCheckHook,
  urllib3,
}:

buildPythonPackage rec {
  pname = "cryptodatahub";
  version = "0.12.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "coroner";
    repo = "cryptodatahub";
    rev = "refs/tags/v${version}";
    hash = "sha256-+IGzXYSaeZjN5AxBu7jXgrnGtrtaSveFiVeNQRBZMNg=";
  };

  postPatch = ''
    substituteInPlace requirements.txt  \
      --replace-fail "attrs>=20.3.0,<22.0.1" "attrs>=20.3.0"
  '';

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    attrs
    pathlib2
    python-dateutil
    six
    urllib3
  ];

  nativeCheckInputs = [
    beautifulsoup4
    pyfakefs
    unittestCheckHook
  ];

  pythonImportsCheck = [ "cryptodatahub" ];

  preCheck = ''
    # failing tests
    rm test/updaters/test_common.py
    # Tests require network access
    rm test/common/test_utils.py
  '';

  meta = with lib; {
    description = "Repository of cryptography-related data";
    homepage = "https://gitlab.com/coroner/cryptodatahub";
    changelog = "https://gitlab.com/coroner/cryptodatahub/-/blob/${version}/CHANGELOG.rst";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
