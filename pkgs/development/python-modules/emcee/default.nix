{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "emcee";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "dfm";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x9y4zwlv6hl7jms2knpa2qrh89ywsl847yb7d93n94gyx2s16p0";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "emcee" ];

  meta = with lib; {
    description = "Kick ass affine-invariant ensemble MCMC sampling";
    homepage = "https://emcee.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
