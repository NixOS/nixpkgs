{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, jax
, jaxlib
}:

buildPythonPackage rec {
  pname = "jmp";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-t78zg6H17l/yBPxYygFjPRdclr88BoTDhPUhsEcNUM0=";
  };

  propagatedBuildInputs = [
    jax
    jaxlib
  ];

  # Test uses unsupported pytest
  doCheck = false;

  pythonImportsCheck = [ "jmp" ];

  meta = with lib; {
    description = "Mixed Precision library for JAX";
    homepage = "https://github.com/deepmind/jmp";
    license = licenses.asl20;
    maintainers = with maintainers; [ harwiltz ];
  };
}
