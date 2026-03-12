{
  lib,
  asn1crypto,
  attrs,
  buildPythonPackage,
  cryptodatahub,
  fetchFromGitLab,
  fetchpatch2,
  pyfakefs,
  setuptools,
  setuptools-scm,
  unittestCheckHook,
  urllib3,
}:

buildPythonPackage rec {
  pname = "cryptoparser";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "coroner";
    repo = "cryptoparser";
    tag = "v${version}";
    hash = "sha256-CsG4hfA3pfE7FwxNfaUTLMS8RV0tv1czoHdIlolUX34=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://gitlab.com/coroner/cryptoparser/-/merge_requests/2.diff";
      hash = "sha256-T8dK6OMR41XUMrZ6B7ZybEtljZJOR2QbCiZl04dT3wA=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asn1crypto
    attrs
    cryptodatahub
    urllib3
  ];

  env.PYTHONDONTWRITEBYTECODE = 1;

  nativeCheckInputs = [
    pyfakefs
    unittestCheckHook
  ];

  postInstall = ''
    find $out -name __pycache__ -type d | xargs rm -rv
  '';

  pythonImportsCheck = [ "cryptoparser" ];

  meta = {
    description = "Security protocol parser and generator";
    homepage = "https://gitlab.com/coroner/cryptoparser";
    changelog = "https://gitlab.com/coroner/cryptoparser/-/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    teams = with lib.teams; [ ngi ];
  };
}
