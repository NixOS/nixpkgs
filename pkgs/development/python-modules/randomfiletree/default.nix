{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "randomfiletree";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "RandomFileTree";
    inherit version;
    hash = "sha256-OpLhLsvwk9xrP8FAXGkDDtMts6ikpx8ockvTR/TEmvw=";
  };

  pythonImportsCheck = [ "randomfiletree" ];
  doCheck = false;

  meta = {
    description = "Create a random file/directory tree/structure in python fortesting purposes";
    homepage = "https://pypi.org/project/RandomFileTree/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twitchy0 ];
  };
}
