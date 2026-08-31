{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  colorama,
  cryptography,
  defusedcsv,
  defusedxml,
  fetchFromGitHub,
  httpx-ntlm,
  httpx,
  jinja2,
  mysql-connector-python,
  psycopg2-binary,
  pyopenssl,
  pysocks,
  pytestCheckHook,
  requests-ntlm,
  requests-toolbelt,
  requests,
  setuptools,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "dirsearch";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maurosoria";
    repo = "dirsearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WKQjtJ5fMVLzX92gOFLqmBLkeM4o2XfVYW9Wz4OmjP4=";
  };

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    colorama
    defusedcsv
    defusedxml
    httpx
    httpx-ntlm
    jinja2
    pyopenssl
    pysocks
    requests
    requests-ntlm
    requests-toolbelt
    setuptools
  ];

  optional-dependencies = {
    db = [
      mysql-connector-python
      psycopg2-binary
    ];
    mysql = [ mysql-connector-python ];
    postgresql = [ psycopg2-binary ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTests = [
    # AssertionError: 'http' != 'https'
    "test_detect_scheme"
  ];

  pythonImportsCheck = [ "dirsearch" ];

  meta = {
    description = "Command-line tool for brute-forcing directories and files in webservers, AKA a web path scanner";
    homepage = "https://github.com/maurosoria/dirsearch";
    changelog = "https://github.com/maurosoria/dirsearch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    mainProgram = "dirsearch";
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
})
