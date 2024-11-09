{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "bottle";
  version = "0.13.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pIhS3HoFE1PT5N491VkM0l3jcLz9lKciN1YeMUzrDIg=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cd test
  '';

  disabledTests =
    [
      "test_delete_cookie"
      "test_error"
      "test_error_in_generator_callback"
      # timing sensitive
      "test_ims"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # https://github.com/bottlepy/bottle/issues/1422
      # ModuleNotFoundError: No module named 'bottle.ext'
      "test_data_import"
      "test_direkt_import"
      "test_from_import"
    ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "https://bottlepy.org/";
    description = "Fast and simple micro-framework for small web-applications";
    mainProgram = "bottle.py";
    downloadPage = "https://github.com/bottlepy/bottle";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
