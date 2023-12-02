{ lib
, buildPythonPackage
, fetchPypi
, chardet
, attrs
, commoncode
, pytestCheckHook
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "debian-inspector";
  version = "31.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "debian_inspector";
    inherit version;
    hash = "sha256-RglPlTRksmm7CYVere7jySy2tIegv6JuulN7Usw9a0c=";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    chardet
    attrs
    commoncode
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "debian_inspector"
  ];

  meta = with lib; {
    description = "Utilities to parse Debian package, copyright and control files";
    homepage = "https://github.com/nexB/debian-inspector";
    license = with licenses; [ asl20 bsd3 mit ];
    maintainers = [ ];
  };
}
