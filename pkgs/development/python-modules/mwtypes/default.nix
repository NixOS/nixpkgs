{
  lib,
  buildPythonPackage,
  fetchPypi,
  jsonable,
  pytestCheckHook,
  fetchpatch2,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mwtypes";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-PgcGUk/27cAIvzfLvRoVX2vHOCab59m+4bciDPmtlW8=";
  };

  patches = [
    # https://github.com/mediawiki-utilities/python-mwtypes/pull/6
    (fetchpatch2 {
      name = "nose-to-pytest.patch";
      url = "https://github.com/mediawiki-utilities/python-mwtypes/commit/58d7f59e4927aaa6278f84576794df713c673058.patch";
      hash = "sha256-jh1uEqqhIK2DyNvVN0XYGM7BXTmypnoC4VoB0V+9JmE=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ jsonable ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Even with 7z included, this test does not pass
  disabledTests = [ "test_open_file" ];

  pythonImportsCheck = [ "mwtypes" ];

  meta = {
    description = "Set of classes for working with MediaWiki data types";
    homepage = "https://github.com/mediawiki-utilities/python-mwtypes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
