{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colorlog";
  version = "6.8.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Pj4HmkH+taG2T5eLXqT0YECpTxHw6Lu4Jh49u+ymTUQ=";
  };

  patches = [
    (fetchpatch2 {
      name = "python313-compat.patch";
      url = "https://github.com/borntyping/python-colorlog/commit/607485def2d60b60c40c0d682574324b47fc30ba.patch";
      hash = "sha256-oO0efAOq7XIwt40Nq5pn2eXen1+p5FiUMDihn8fYAFg=";
      includes = [ "colorlog/wrappers.py" ];
    })
  ];

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "colorlog" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
