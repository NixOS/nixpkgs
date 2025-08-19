{
  lib,
  buildPythonPackage,
  certifi,
  chardet,
  fetchFromGitHub,
  idna,
  pythonOlder,
  requests,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "frigidaire";
  version = "0.18.24";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bm1549";
    repo = "frigidaire";
    tag = version;
    hash = "sha256-lpwzXeuFPvWV26AIAfzBHY3IiwEc8vThTXc/F0iyV1o=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-warn 'version = "SNAPSHOT"' 'version = "${version}"'
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

  meta = with lib; {
    description = "Python API for the Frigidaire devices";
    homepage = "https://github.com/bm1549/frigidaire";
    changelog = "https://github.com/bm1549/frigidaire/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
