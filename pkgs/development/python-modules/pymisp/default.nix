{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  deprecated,
  docutils,
  extract-msg,
  fetchFromGitHub,
  lief,
  myst-parser,
  neo4j,
  nix-update-script,
  oletools,
  poetry-core,
  pure-magic-rs,
  pydeep2,
  pyfaup-rs,
  pytestCheckHook,
  python-dateutil,
  reportlab,
  requests,
  rtfde,
  sphinx-autodoc-typehints,
  sphinx,
  urllib3,
  validators,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymisp";
  version = "2.5.34.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MISP";
    repo = "PyMISP";
    tag = "v${finalAttrs.version}";
    hash = "sha256-68XJ6lqoNGnUneNIu0ZOKZhrumrt6CPLAt45UaZC5q0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    deprecated
    python-dateutil
    requests
  ];

  optional-dependencies = {
    brotli = [ urllib3 ];
    docs = [
      docutils
      myst-parser
      sphinx
      sphinx-autodoc-typehints
    ];
    email = [
      extract-msg
      oletools
      rtfde
    ];
    fileobjects = [
      lief
      pure-magic-rs
      pydeep2
    ];
    neo4j = [ neo4j ];
    openioc = [ beautifulsoup4 ];
    pdfexport = [ reportlab ];
    url = [ pyfaup-rs ];
    virustotal = [ validators ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTestPaths = [
    # Test requires network access
    "tests/test_reportlab.py"
  ];

  disabledTests = [
    # AttributeError
    "test_analyst_data_object_object_attribute_alternative"
    "test_analyst_data_on_object"
    "test_analyst_data_on_object_alternative"
    "test_analyst_data_on_object_attribute"
    "test_bom_encoded"
    "test_default_attributes"
    "test_feed"
    "test_git_vuln_finder"
    "test_handling_of_various_email_types"
    "test_mail_1"
    "test_mail_1_headers_only"
    "test_mail_multiple_to"
    "test_mimeType"
    "test_msg"
    "test_obj_default_values"
    "test_object_galaxy"
    "test_object_tag"
    "test_to_dict_json_format"
  ];

  pythonImportsCheck = [ "pymisp" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library using the MISP Rest API";
    homepage = "https://github.com/MISP/PyMISP";
    changelog = "https://github.com/MISP/PyMISP/blob/${finalAttrs.src.rev}/CHANGELOG.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
