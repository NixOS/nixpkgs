{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  curl-impersonate-chrome,
  cffi,
  certifi,
}:

buildPythonPackage rec {
  pname = "curl-cffi";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "yifeikong";
    repo = "curl_cffi";
    rev = "refs/tags/v${version}";
    hash = "sha256-bNBpZAIdfub2osByo827RBw/gouCmNt8uVN0y1KdcUk=";
  };

  patches = [ ./use-system-libs.patch ];
  buildInputs = [ curl-impersonate-chrome ];

  format = "pyproject";
  build-system = [ setuptools ];

  nativeBuildInputs = [ cffi ];
  propagatedBuildInputs = [
    cffi
    certifi
  ];

  pythonImportsCheck = [ "curl_cffi" ];

  meta = with lib; {
    description = "Python binding for curl-impersonate via cffi";
    homepage = "https://curl-cffi.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
