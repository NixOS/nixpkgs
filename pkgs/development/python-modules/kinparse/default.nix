{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  future,
  pyparsing,
}:

buildPythonPackage {
  pname = "kinparse";
  version = "unstable-2019-12-18";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xesscorp";
    repo = "kinparse";
    rev = "eeb3f346d57a67a471bdf111f39bef8932644481";
    sha256 = "1nrjnybwzy93c79yylcwmb4lvkx7hixavnjwffslz0zwn32l0kx3";
  };

  doCheck = true;
  pythonImportsCheck = [ "kinparse" ];

  nativeCheckInputs = [ pytest ];

  propagatedBuildInputs = [
    future
    pyparsing
  ];

  meta = with lib; {
    description = "Parser for KiCad EESCHEMA netlists";
    mainProgram = "kinparse";
    homepage = "https://github.com/xesscorp/kinparse";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
