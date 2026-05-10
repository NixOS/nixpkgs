{
  lib,
  buildPythonPackage,
  certifi,
  chardet,
  fetchFromGitHub,
  idna,
  requests,
  setuptools,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "frigidaire";
  version = "0.18.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bm1549";
    repo = "frigidaire";
    tag = finalAttrs.version;
    hash = "sha256-OVaXo1UFB0deCHfDXR+uUnIsPsW6RhE/OJLG1WD4Ykg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-warn 'version = "SNAPSHOT"' 'version = "${finalAttrs.version}"'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    certifi
    chardet
    idna
    requests
    urllib3
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "frigidaire" ];

  meta = {
    description = "Python API for the Frigidaire devices";
    homepage = "https://github.com/bm1549/frigidaire";
    changelog = "https://github.com/bm1549/frigidaire/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
