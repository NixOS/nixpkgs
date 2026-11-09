{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  pynacl,
  requests,
}:

buildPythonPackage rec {
  pname = "pynuki";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "pynuki";
    tag = version;
    hash = "sha256-oEdR4Ze11IfNzNup8oOECDTIWPjjAyE/KhGdgAQZHGE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.13.0,<0.14.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    pynacl
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynuki" ];

  meta = {
    description = "Python bindings for nuki.io bridges";
    homepage = "https://github.com/pschmitt/pynuki";
    changelog = "https://github.com/pschmitt/pynuki/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
