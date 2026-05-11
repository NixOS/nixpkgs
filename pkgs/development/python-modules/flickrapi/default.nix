{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  requests-toolbelt,
  requests-oauthlib,
  six,
  pytestCheckHook,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flickrapi";
  version = "2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sybrenstuvel";
    repo = "flickrapi";
    rev = "version-${version}";
    hash = "sha256-vRZrlXKI0UDdmDevh3XUngH4X8G3VlOCSP0z/rxhIgw=";
  };

  postPatch = ''
    substituteInPlace tests/test_tokencache.py \
      --replace-fail "assertEquals" "assertEqual" \
      --replace-fail "assertNotEquals" "assertNotEqual"
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    requests-toolbelt
    requests-oauthlib
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Tests require network access
    "test_default_format"
    "test_etree_default_format"
    "test_etree_format_error"
    "test_etree_format_happy"
    "test_explicit_format"
    "test_json_callback_format"
    "test_json_format"
    "test_parsed_json_format"
    "test_walk"
    "test_xmlnode_format"
    "test_xmlnode_format_error"
    "test_upload"
  ];

  pythonImportsCheck = [ "flickrapi" ];

  meta = {
    description = "Python interface to the Flickr API";
    homepage = "https://stuvel.eu/flickrapi";
    changelog = "https://github.com/sybrenstuvel/flickrapi/blob/version-${version}/CHANGELOG.md";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ obadz ];
  };
}
