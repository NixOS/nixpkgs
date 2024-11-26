{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  dill,
  mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "expiringdict";
  version = "1.2.2";
  pyproject = true;

  # use fetchFromGitHub instead of fetchPypi because the test suite of
  # the package is not included into the PyPI tarball
  src = fetchFromGitHub {
    owner = "mailgun";
    repo = "expiringdict";
    rev = "refs/tags/v${version}";
    hash = "sha256-vRhJSHIqc51I+s/wndtfANM44CKW3QS1iajqyoSBf0I=";
  };

  patches = [
    # apply mailgun/expiringdict#49 to address NixOS/nixpkgs#326513
    (fetchpatch2 {
      url = "https://github.com/mailgun/expiringdict/commit/1c0f82232d20f8b3b31c9269a4d0e9510c1721a6.patch";
      hash = "sha256-IeeJVb2tOwRhEPNGqM30fNZyz3jFcnZNWC3I6K1+hSY=";
    })

    # apply mailgun/expiringdict#56 for compatibility with Python 3.12
    (fetchpatch2 {
      url = "https://github.com/mailgun/expiringdict/commit/976faf3664d54049e443aca054f5819db834577b.patch";
      hash = "sha256-FNdnU6iUMyED5j8oAjhmJTR7zQeEc/Z5s64pdeT4F8w=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    dill
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "expiringdict" ];

  meta = with lib; {
    changelog = "https://github.com/mailgun/expiringdict/blob/${src.rev}/CHANGELOG.rst";
    description = "Dictionary with auto-expiring values for caching purposes";
    homepage = "https://github.com/mailgun/expiringdict";
    license = licenses.asl20;
    maintainers = with maintainers; [ gravndal ];
  };
}
