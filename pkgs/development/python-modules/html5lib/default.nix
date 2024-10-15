{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest-expect,
  pytestCheckHook,
  lxml,
}:

buildPythonPackage rec {
  pname = "html5lib";
  version = "1.2";
  format = "setuptools";

  # html5lib has not received any updates since 2020
  # This fork mainly focus on fixing compatibility issues
  # and remove ancient python versions support
  # See https://github.com/html5lib/html5lib-python/issues/577
  src = fetchPypi {
    pname = "html5lib_modern";
    inherit version;
    sha256 = "sha256-H62/wn6pVUMScOTnmkpMKQuhHDowmKlcwi3HPjEqF2g=";
  };

  checkInputs = [ lxml ];

  nativeCheckInputs = [
    pytest-expect
    pytestCheckHook
  ];

  meta = {
    homepage = "https://pypi.org/project/html5lib-modern/";
    description = "HTML parser based on WHAT-WG HTML5 specification";
    longDescription = ''
      html5lib is a pure-python library for parsing HTML. It is designed to
      conform to the WHATWG HTML specification, as is implemented by all
      major web browsers.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      domenkozar
      prikhi
    ];
  };
}
