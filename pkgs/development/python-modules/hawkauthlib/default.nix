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
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "hawkauthlib";
    tag = "v${version}";
    hash = "sha256-dFBGrk7vdZMNTuWvXXWXA4iF/vmiUnK9ds8edN2Yt10=";
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
