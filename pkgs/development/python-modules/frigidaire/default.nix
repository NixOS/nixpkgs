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
  version = "0.18.23";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bm1549";
    repo = "frigidaire";
    rev = "refs/tags/${version}";
    hash = "sha256-RzwTQRo5cIh6I8VQAJNcLg5TBiF6dAnZICGfvwCvx5Y=";
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
    changelog = "https://github.com/bm1549/frigidaire/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
