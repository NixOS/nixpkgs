{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "py-expression-eval";
  version = "0.3.13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "axiacore";
    repo = "py-expression-eval";
    rev = "v${version}";
    sha256 = "sha256-IKNTJ0FT1EHismpdeDje12RTZ6XYv9gsM08kCIzWJdg=";
  };

  meta = {
    homepage = "https://github.com/AxiaCore/py-expression-eval/";
    description = "Python Mathematical Expression Evaluator";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cynerd ];
  };
}
