{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, chardet
, requests
, ruamel-yaml
, setuptools-scm
, six
, semver
, pytestCheckHook
, openapi-spec-validator
}:

buildPythonPackage rec {
  pname = "prance";
  version = "0.21.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "RonnyPfannschmidt";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-kGANMHfWwhW3ZBw2ZVCJZR/bV2EPhcydMKhDeDTVwcQ=";
  };

  patches = [
    # Fix for openapi-spec-validator 0.5.0+:
    # https://github.com/RonnyPfannschmidt/prance/pull/132
    (fetchpatch {
      name = "1-openapi-spec-validator-upgrade.patch";
      url = "https://github.com/RonnyPfannschmidt/prance/commit/55503c9b12b685863c932ededac996369e7d288a.patch";
      hash = "sha256-7SOgFsk2aaaaAYS8WJ9axqQFyEprurn6Zn12NcdQ9Bg=";
    })
    (fetchpatch {
      name = "2-openapi-spec-validator-upgrade.patch";
      url = "https://github.com/RonnyPfannschmidt/prance/commit/7e59cc69c6c62fd04875105773d9d220bb58fea6.patch";
      hash = "sha256-j6vmY3NqDswp7v9682H+/MxMGtFObMxUeL9Wbiv9hYw=";
    })
    (fetchpatch {
      name = "3-openapi-spec-validator-upgrade.patch";
      url = "https://github.com/RonnyPfannschmidt/prance/commit/7e575781d83845d7ea0c2eff57644df9b465c7af.patch";
      hash = "sha256-rexKoQ+TH3QmP20c3bA+7BLMLc+fkVhn7xsq+gle1Aw=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=prance --cov-report=term-missing --cov-fail-under=90" "" \
      --replace "chardet>=3.0,<5.0" "chardet"
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    chardet
    requests
    ruamel-yaml
    six
    semver
  ];

  nativeCheckInputs = [
    pytestCheckHook
    openapi-spec-validator
  ];

  # Disable tests that require network
  disabledTestPaths = [
    "tests/test_convert.py"
  ];
  disabledTests = [
    "test_fetch_url_http"
  ];
  pythonImportsCheck = [ "prance" ];

  meta = with lib; {
    description = "Resolving Swagger/OpenAPI 2.0 and 3.0.0 Parser";
    homepage = "https://github.com/RonnyPfannschmidt/prance";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
