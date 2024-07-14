{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
}:

buildPythonPackage rec {
  pname = "linecache2";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Syb/TnEQ23butvWntkqCYjg51ZXCA47tpmLyott46Xw=";
  };

  buildInputs = [ pbr ];
  # circular dependencies for tests
  doCheck = false;

  meta = with lib; {
    description = "Backport of linecache to older supported Pythons";
    homepage = "https://github.com/testing-cabal/linecache2";
    license = licenses.psfl;
  };
}
