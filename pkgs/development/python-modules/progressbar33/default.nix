{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "progressbar33";
  version = "2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Uf4NmztAI9svmD7szfyMmEa4TbhEO5vuACx/WPQ3bv8=";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/progressbar33";
    description = "Text progressbar library for python";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ twey ];
  };
}
