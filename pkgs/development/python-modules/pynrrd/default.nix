{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  numpy,
  nptyping,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pynrrd";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhe";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-B/G46/9Xf1LRu02p0X4/UeW1RYotSXKXRO9VZDPhkNU=";
  };

  propagatedBuildInputs = [
    numpy
    nptyping
    typing-extensions
  ];

  pythonImportsCheck = [ "nrrd" ];

  meta = with lib; {
    homepage = "https://github.com/mhe/pynrrd";
    description = "Simple pure-Python reader for NRRD files";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
