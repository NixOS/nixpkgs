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
    sha256 = "0z79g3ds5wk2lvnqw0y2jpakjf32h95bd9zmnvp7dnqhf57gy9jb";
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
