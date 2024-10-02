{
  stdenv,
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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "yifeikong";
    repo = "curl_cffi";
    rev = "refs/tags/v${version}";
    hash = "sha256-s8P/7erdAeGZuykUrgpCcm0a4ym3Y8F6kKFXoDXsOdQ=";
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

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  pythonImportsCheck = [ "curl_cffi" ];

  meta = with lib; {
    description = "Python binding for curl-impersonate via cffi";
    homepage = "https://curl-cffi.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
