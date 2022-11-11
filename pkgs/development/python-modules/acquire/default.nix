{ lib
, buildPythonPackage
, defusedxml
, dissect-cstruct
, dissect-target
, fetchFromGitHub
, minio
, pycryptodome
, pytestCheckHook
, pythonOlder
, requests
, requests-toolbelt
, rich
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "acquire";
  version = "3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "acquire";
    rev = version;
    hash = "sha256-YwmrdqWG5qD621+jQMVyTM0Uy0yXCVPv9zfVhZ+ohg0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    defusedxml
    dissect-cstruct
    dissect-target
  ];

  passthru.optional-dependencies = {
    full = [
      dissect-target
      minio
      pycryptodome
      requests
      requests-toolbelt
      rich
    ] ++ dissect-target.optional-dependencies.full;
  };

  checkInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.full;

  pythonImportsCheck = [
    "acquire"
  ];

  meta = with lib; {
    description = "Tool to quickly gather forensic artifacts from disk images or a live system";
    homepage = "https://github.com/fox-it/acquire";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
