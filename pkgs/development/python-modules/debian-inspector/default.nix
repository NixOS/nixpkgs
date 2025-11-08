{
  lib,
  buildPythonPackage,
  fetchPypi,
  chardet,
  attrs,
  commoncode,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "debian-inspector";
  version = "31.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "debian_inspector";
    inherit version;
    hash = "sha256-uyFsYrb7D9cM1OQzkIERX0oV711uI/TEKF6t67z8egU=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  dependencies = [
    chardet
    attrs
  ];

  nativeCheckInputs = [
    commoncode
    pytestCheckHook
  ];

  pythonImportsCheck = [ "debian_inspector" ];

  meta = with lib; {
    description = "Utilities to parse Debian package, copyright and control files";
    homepage = "https://github.com/nexB/debian-inspector";
    changelog = "https://github.com/aboutcode-org/debian-inspector/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [
      asl20
      bsd3
      mit
    ];
    maintainers = [ ];
  };
}
