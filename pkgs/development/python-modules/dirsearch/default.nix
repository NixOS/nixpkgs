{
  lib,
  callPackage,
  fetchFromGitHub,
  buildPythonPackage,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  beautifulsoup4,
  colorama,
  defusedcsv,
  defusedxml,
  httpx,
  httpx-ntlm,
  jinja2,
  pyopenssl,
  pysocks,
  requests,
  requests-ntlm,
  requests-toolbelt,

  # optional dependencies
  mysql-connector-python,
  psycopg,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dirsearch";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "maurosoria";
    repo = "dirsearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WKQjtJ5fMVLzX92gOFLqmBLkeM4o2XfVYW9Wz4OmjP4=";
  };

  patches = [
    # fixes test_detect_scheme not working without network
    # see https://github.com/maurosoria/dirsearch/issues/1592
    (fetchpatch {
      url = "https://github.com/maurosoria/dirsearch/commit/8f2b3cceee0a27c0670ed9471b70dd666c73d6a6.patch";
      hash = "sha256-KnVYiQftq8DgbSdXPxsCCOTxS1e7vOqf/4sDqYXkX9A=";
    })
  ];

  pyproject = true;

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
  ];

  # dirsearch-build-native builds the rust backend when called
  # this is meant for venvs and doesn't work for the nix package
  postInstall = ''
    rm $out/bin/dirsearch-build-native
    rm -r $out/lib/python*/site-packages/dirsearch/native
  '';

  # tests
  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues finalAttrs.passthru.optional-dependencies);
  pythonImportsCheck = [ "dirsearch" ];
  __darwinAllowLocalNetworking = true;

  # relax all deps because upstream pins versions "to prevent supply chain attacks"
  pythonRelaxDeps = true;

  passthru = {
    dirsearch-native = callPackage ./dirsearch-native.nix {
      inherit (finalAttrs) src meta;
    };
    optional-dependencies = rec {
      rustbackend = [ finalAttrs.passthru.dirsearch-native ];
      mysql = [ mysql-connector-python ];
      postgresql = [ psycopg ];
      db = mysql ++ postgresql;
      full = rustbackend ++ db;
    };
  };

  meta = {
    changelog = "https://github.com/maurosoria/dirsearch/releases/tag/${finalAttrs.src.tag}";
    description = "Command-line tool for brute-forcing directories and files in webservers, AKA a web path scanner";
    homepage = "https://github.com/maurosoria/dirsearch";
    license = lib.licenses.gpl2Only;
    mainProgram = "dirsearch";
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
})
