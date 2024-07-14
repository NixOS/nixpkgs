{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
  decorator,
  py,
  mock,
  pytest,
}:

buildPythonPackage rec {
  pname = "retry";
  version = "0.9.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+L+ouZtpxFBtb1vTsKq/d/mM2xfzyfw/XKggAzM2+6Q=";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    decorator
    py
  ];

  nativeCheckInputs = [
    mock
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Easy to use retry decorator";
    homepage = "https://github.com/invl/retry";
    license = licenses.asl20;
  };
}
