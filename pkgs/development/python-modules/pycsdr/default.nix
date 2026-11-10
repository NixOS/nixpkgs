{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  csdr,
}:

buildPythonPackage rec {
  pname = "pycsdr";
  version = "0.18.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = "pycsdr";
    rev = version;
    hash = "sha256-OzkH1L9bFXf+kK8OPjRXpGz+fPCs67spJfXyV28NWWQ=";
  };

  postPatch = ''
    substituteInPlace src/pycsdr.cpp \
      --replace-fail "PyModuleDef_HEAD_INIT," ".m_base = PyModuleDef_HEAD_INIT,"
  '';

  propagatedBuildInputs = [ csdr ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "pycsdr" ];

  meta = {
    homepage = "https://github.com/jketterl/pycsdr";
    description = "Bindings for the csdr library";
    license = lib.licenses.gpl3Only;
  };
}
