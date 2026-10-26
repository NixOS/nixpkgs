{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "hkavr";
  version = "0.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-wa0yS0KPdrQUuxxViweESD6Itn2rFlTwwrPQ0COWIPc=";
  };

  propagatedBuildInputs = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "hkavr" ];

  meta = {
    description = "Library for interacting with Harman Kardon AVR controllers";
    homepage = "https://github.com/Devqon/hkavr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
