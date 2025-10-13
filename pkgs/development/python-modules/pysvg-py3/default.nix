{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,
}:

buildPythonPackage rec {
  pname = "pysvg-py3";
  version = "0.2.2-post3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alorence";
    repo = "pysvg-py3";
    rev = version;
    sha256 = "1slync0knpcjgl4xpym8w4249iy6vmrwbarpnbjzn9xca8g1h2f0";
  };

  checkPhase = ''
    runHook preCheck
    mkdir testoutput
    ${python.interpreter} sample/tutorial.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "pysvg" ];

  meta = {
    homepage = "https://github.com/alorence/pysvg-py3";
    description = "Creating SVG with Python";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ davidak ];
  };
}
