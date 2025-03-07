{
  lib,
  buildPythonPackage,
  unittestCheckHook,
  fetchPypi,
  pythonOlder,
  glibcLocales,
}:

buildPythonPackage rec {
  pname = "pystache";
  version = "0.6.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nyONWgbxiEPg1JHY5OKS3AP+1qVMsKXDS+N6P6qXMXQ=";
  };

  LC_ALL = "en_US.UTF-8";

  buildInputs = [ glibcLocales ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pystache" ];

  meta = with lib; {
    description = "Framework-agnostic, logic-free templating system inspired by ctemplate and et";
    homepage = "https://github.com/defunkt/pystache";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
