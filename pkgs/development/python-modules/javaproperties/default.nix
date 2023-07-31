{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, setuptools
, wheel
, six
, pytestCheckHook
, python-dateutil
}:

buildPythonPackage rec {
  version = "0.8.1";
  pname = "javaproperties";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9zXFremg2rtrmRs/ZDbDTfzEqDFBhtXFDkKR9gpvLJs=";
  };

  patches = [
    (fetchpatch {
      name = "remove-wheel-dependency-constraint.patch";
      url = "https://github.com/jwodder/javaproperties/commit/e588c4f4e6c6255ed4ca2d9fcdec8ebaf0fa4613.patch";
      hash = "sha256-ssePCVlJuHPJpPyFET3FnnWRlslLnZbnfn42g52yVN4=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    python-dateutil
    pytestCheckHook
  ];

  disabledTests = [
    "time"
  ];

  disabledTestPaths = [
    "test/test_propclass.py"
  ];

  meta = with lib; {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
