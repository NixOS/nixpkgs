{ lib
, buildPythonPackage
, fetchFromGitHub
, iso8601
, bottle
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "m3u8";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "globocom";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-sxLT3a9f38RZqzEzqyZos3G38vzHPzhMexfBN2qzbxQ=";
  };

  propagatedBuildInputs = [
    iso8601
  ];

  nativeCheckInputs = [
    bottle
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_load_should_create_object_from_uri"
    "test_load_should_create_object_from_uri_with_relative_segments"
    "test_load_should_remember_redirect"
    "test_raise_timeout_exception_if_timeout_happens_when_loading_from_uri"
  ];

  pythonImportsCheck = [
    "m3u8"
  ];

  meta = with lib; {
    description = "Python m3u8 parser";
    homepage = "https://github.com/globocom/m3u8";
    changelog = "https://github.com/globocom/m3u8/releases/tag//${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
