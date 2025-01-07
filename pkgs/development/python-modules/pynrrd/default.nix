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
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhe";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-R/bUItF2BaKTFdMNBHFJKq0jSX6z49e8CGXENUn07SU=";
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
