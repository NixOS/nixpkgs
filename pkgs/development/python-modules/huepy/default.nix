{
  lib,
  fetchPypi,
  setuptools,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "huepy";
  version = "1.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "huepy";
    inherit version;
    hash = "sha256-Wym+73lzEvt2BhiLxc2Y94q49+AVdkJ6kxLxybILdZ0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "huepy" ];

  # no test
  doCheck = false;

  meta = with lib; {
    description = "Print awesomely in terminals";
    homepage = "https://pypi.org/project/huepy/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tochiaha ];
    platforms = platforms.all;
  };
}
