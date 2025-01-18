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
    repo = pname;
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

  meta = with lib; {
    homepage = "https://github.com/alorence/pysvg-py3";
    description = "Creating SVG with Python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ davidak ];
  };
}
