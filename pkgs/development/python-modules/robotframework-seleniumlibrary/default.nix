{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, robotframework
, robotframework-pythonlibcore
, selenium
, approvaltests
, pytest-mockito
, pytestCheckHook
, robotstatuschecker
}:

buildPythonPackage rec {
  version = "6.1.2";
  format = "setuptools";
  pname = "robotframework-seleniumlibrary";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "SeleniumLibrary";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-QbAwPm1Y76KPIcHkopiyISULQSwUet021erFa/zi8Zw=";
  };

  propagatedBuildInputs = [
    robotframework
    robotframework-pythonlibcore
    selenium
  ];

  nativeCheckInputs = [
    approvaltests
    pytest-mockito
    pytestCheckHook
    robotstatuschecker
  ];

  disabledTestPaths = [
    # https://github.com/robotframework/SeleniumLibrary/issues/1804
    "utest/test/keywords/test_webdrivercache.py"
  ];

  disabledTests = [
    "test_create_opera_executable_path_not_set"
    "test_create_opera_executable_path_set"
    "test_create_opera_with_options"
    "test_create_opera_with_service_log_path_real_path"
    "test_get_executable_path"
    "test_get_ff_profile_instance_FirefoxProfile"
    "test_has_options"
    "test_importer"
    "test_log_file_with_index_exist"
    "test_opera"
    "test_single_method"
  ];

  meta = with lib; {
    changelog = "https://github.com/robotframework/SeleniumLibrary/blob/${src.rev}/docs/SeleniumLibrary-${version}.rst";
    description = "Web testing library for Robot Framework";
    homepage = "https://github.com/robotframework/SeleniumLibrary";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
