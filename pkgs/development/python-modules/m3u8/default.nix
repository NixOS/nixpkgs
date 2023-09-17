{ lib
, buildPythonPackage
, fetchFromGitHub
, iso8601
, bottle
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "m3u8";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "globocom";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-JLYRkibcvmNct2eIBfBP7z3gR680xhZL/Kn/1S7feoo=";
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
  ];

  pythonImportsCheck = [
    "m3u8"
  ];

  meta = with lib; {
    homepage = "https://github.com/globocom/m3u8";
    description = "Python m3u8 parser";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
