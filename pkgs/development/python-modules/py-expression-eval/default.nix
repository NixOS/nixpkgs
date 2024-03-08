{ lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "py-expression-eval";
  version = "0.3.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "axiacore";
    repo = "py-expression-eval";
    rev = "v${version}";
    sha256 = "YxhZd8V6ofphcNdcbBbrT5mc37O9c6W1mfhsvFVC+KM=";
  };

  meta = with lib; {
    homepage = "https://github.com/AxiaCore/py-expression-eval/";
    description = "Python Mathematical Expression Evaluator";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ cynerd ];
  };
}
