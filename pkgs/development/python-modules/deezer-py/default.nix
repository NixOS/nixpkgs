{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "deezer-py";
  version = "1.3.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-saMy+IeAy6H9SgS8XHnZ9klFerGyr+vQqhuCtimgbEo=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "requests" ];

  meta = {
    homepage = "https://gitlab.com/RemixDev/deezer-py";
    description = "Wrapper for all Deezer's APIs";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ natto1784 ];
  };
}
