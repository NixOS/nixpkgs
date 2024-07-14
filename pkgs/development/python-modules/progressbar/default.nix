{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "progressbar";
  version = "2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XYHLUp2i4iO1OWKv1sjKDwXGZw5AMJpyGerMNq+bbGM=";
  };

  # invalid command 'test'
  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/progressbar";
    description = "Text progressbar library for python";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
