{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "paste";
  version = "3.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cdent";
    repo = "paste";
    rev = "refs/tags/${version}";
    hash = "sha256-lpQMzrRpcG5TqWm/FJn4oo9TV8Skf0ypZVeQC4y8p1U=";
  };

  postPatch = ''
    patchShebangs tests/cgiapp_data/
  '';

  propagatedBuildInputs = [
    setuptools
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # broken test
    "test_file_cache"
    # requires network connection
    "test_proxy_to_website"
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/cdent/paste/issues/72
    "test_form"
  ];

  pythonNamespaces = [
    "paste"
  ];

  meta = with lib; {
    description = "Tools for using a Web Server Gateway Interface stack";
    homepage = "https://pythonpaste.readthedocs.io/";
    changelog = "https://github.com/cdent/paste/blob/${version}/docs/news.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
