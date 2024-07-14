{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  progressbar231 ? null,
  progressbar33,
  mock,
}:

buildPythonPackage rec {
  pname = "bitmath";
  version = "1.3.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KTMl8B5l3v6WaFMRHfEdOSFetwWpZ8sRWFHajEz6Prg=";
  };

  nativeCheckInputs = [
    (if isPy3k then progressbar33 else progressbar231)
    mock
  ];

  meta = with lib; {
    description = "Module for representing and manipulating file sizes with different prefix";
    mainProgram = "bitmath";
    homepage = "https://github.com/tbielawa/bitmath";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
