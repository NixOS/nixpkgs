{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  setuptools,

  # optional dependencies
  pykerberos,

  # test dependencies
  mock,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "pure-sasl";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thobbs";
    repo = "pure-sasl";
    tag = version;
    hash = "sha256-AHoZ3QZLr0JLE8+a2zkB06v2wRknxhgm/tcEPXaJX/U=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    gssapi = [ pykerberos ];
  };

  pythonImportsCheck = [
    "puresasl"
    "puresasl.client"
    "puresasl.mechanisms"
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    six
  ]
  ++ lib.concatAttrValues optional-dependencies;

  meta = {
    description = "Reasonably high-level SASL client written in pure Python";
    homepage = "http://github.com/thobbs/pure-sasl";
    changelog = "https://github.com/thobbs/pure-sasl/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
