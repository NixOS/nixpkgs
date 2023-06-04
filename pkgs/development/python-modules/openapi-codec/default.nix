{ lib
, buildPythonPackage
, fetchFromGitHub

, coverage
, pytestCheckHook
, flake8
# runtime
, coreapi
}:

buildPythonPackage rec {
  pname = "openapi-codec";
  version = "1.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "core-api";
    repo = "python-openapi-codec";
    rev = version;
    hash = "sha256-2pRt/AuNofj2k9FaO5JNBt4fFZwtZyvgalyPp0u70EY=";
  };

  propagatedBuildInputs = [
    coreapi
  ];

  nativeCheckInputs = [
    coverage
    pytestCheckHook
    flake8
  ];

  pythonImportsCheck = [ "openapi_codec" ];

  checkPhase = ''
    python runtests
  '';

  meta = with lib; {
    description = "An OpenAPI codec for Core API";
    homepage = "https://github.com/Core-api/python-openapi-codec";
    license = licenses.bsd2;
    maintainers = with maintainers; [ s1341 ];
    platforms = platforms.linux;
  };
}
