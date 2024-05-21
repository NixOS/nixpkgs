{ lib
, buildPythonPackage
, fetchPypi
, pbr
, decorator
, py
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "retry";
  version = "0.9.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f8bfa8b99b69c4506d6f5bd3b0aabf77f98cdb17f3c9fc3f5ca820033336fba4";
  };

  nativeBuildInputs = [
    pbr
  ];

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
