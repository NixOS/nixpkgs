{
  lib,
  buildPythonPackage,
  fetchPypi,
  markdown,
  isPy27,
}:

buildPythonPackage rec {
  pname = "python-markdown-math";
  version = "0.8";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hWQhKvZ5/BjVPzhoHxYID809GGBz8jglx86G+t0+NjU=";
  };

  nativeCheckInputs = [ markdown ];

  meta = {
    description = "Math extension for Python-Markdown";
    homepage = "https://github.com/mitya57/python-markdown-math";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ klntsky ];
  };
}
