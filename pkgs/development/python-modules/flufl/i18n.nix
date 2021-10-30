{ buildPythonPackage, fetchPypi, atpublic }:

buildPythonPackage rec {
  pname = "flufl.i18n";
  version = "3.2";

  propagatedBuildInputs = [ atpublic ];

  doCheck = false;

  pythonImportsCheck = [ "flufl.i18n" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "c35c8f8eab66adb7fd64a1420860105066d2b36cb655b33ffb14afe8e223ed62";
  };
}
