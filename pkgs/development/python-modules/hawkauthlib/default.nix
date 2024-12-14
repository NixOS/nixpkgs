{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  webob,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "hawkauthlib";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "hawkauthlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-UW++gLQX1U4jFwccL+O5wl2r/d2OZ5Ug0wcnSfqtIVc=";
  };

  postPatch = ''
    substituteInPlace hawkauthlib/tests/* \
        --replace-warn 'assertEquals' 'assertEqual'
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    webob
  ];

  pythonImportsCheck = [ "hawkauthlib" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/mozilla-services/hawkauthlib";
    description = "Hawk Access Authentication protocol";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
