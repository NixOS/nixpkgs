{
  lib,
  asn1crypto,
  attrs,
  buildPythonPackage,
  cryptodatahub,
<<<<<<< HEAD
  fetchFromGitLab,
  fetchpatch2,
  pyfakefs,
  pythonOlder,
  setuptools,
  setuptools-scm,
  unittestCheckHook,
=======
  fetchPypi,
  python-dateutil,
  pythonOlder,
  setuptools,
  setuptools-scm,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  urllib3,
}:

buildPythonPackage rec {
  pname = "cryptoparser";
<<<<<<< HEAD
  version = "1.0.2";
=======
  version = "1.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.9";

<<<<<<< HEAD
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
=======
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bEvhMVcm9sXlfhxUD2K4N10nusgxpGYFJQLtJE1/qok=";
  };

  patches = [
    # https://gitlab.com/coroner/cryptoparser/-/merge_requests/2
    ./fix-dirs-exclude.patch
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asn1crypto
    attrs
    cryptodatahub
<<<<<<< HEAD
    urllib3
  ];

  env.PYTHONDONTWRITEBYTECODE = 1;

  nativeCheckInputs = [
    pyfakefs
    unittestCheckHook
  ];

  postInstall = ''
    find $out -name __pycache__ -type d | xargs rm -rv
=======
    python-dateutil
    urllib3
  ];

  postInstall = ''
    find $out -name "__pycache__" -type d | xargs rm -rv

    # Prevent creating more binary byte code later (e.g. during
    # pythonImportsCheck)
    export PYTHONDONTWRITEBYTECODE=1
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  pythonImportsCheck = [ "cryptoparser" ];

<<<<<<< HEAD
  meta = {
    description = "Security protocol parser and generator";
    homepage = "https://gitlab.com/coroner/cryptoparser";
    changelog = "https://gitlab.com/coroner/cryptoparser/-/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ kranzes ];
    teams = with lib.teams; [ ngi ];
=======
  meta = with lib; {
    description = "Security protocol parser and generator";
    homepage = "https://gitlab.com/coroner/cryptoparser";
    changelog = "https://gitlab.com/coroner/cryptoparser/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kranzes ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
