{
  lib,
  asn1crypto,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitLab,
  pyfakefs,
  python-dateutil,
  pythonOlder,
  setuptools,
  setuptools-scm,
  unittestCheckHook,
  urllib3,
}:

buildPythonPackage rec {
  pname = "cryptodatahub";
<<<<<<< HEAD
  version = "1.0.2";
=======
  version = "1.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitLab {
    owner = "coroner";
    repo = "cryptodatahub";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-DQspaa9GsnRjETKUca2i91iBPbT4qATmKiL8M0nBP/A=";
=======
    rev = "refs/tags/v${version}";
    hash = "sha256-taYpSYkfucc9GQpVDiAZgCt/D3Akld20LkFEhsdKH0Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asn1crypto
    attrs
    python-dateutil
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
<<<<<<< HEAD
=======
    rm test/common/test_key.py
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # Tests require network access
    rm test/common/test_utils.py
  '';

<<<<<<< HEAD
  meta = {
    description = "Repository of cryptography-related data";
    homepage = "https://gitlab.com/coroner/cryptodatahub";
    changelog = "https://gitlab.com/coroner/cryptodatahub/-/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mpl20;
    teams = with lib.teams; [ ngi ];
=======
  meta = with lib; {
    description = "Repository of cryptography-related data";
    homepage = "https://gitlab.com/coroner/cryptodatahub";
    changelog = "https://gitlab.com/coroner/cryptodatahub/-/blob/${version}/CHANGELOG.rst";
    license = licenses.mpl20;
    maintainers = [ ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
