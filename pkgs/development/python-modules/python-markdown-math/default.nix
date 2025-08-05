{
  lib,
  buildPythonPackage,
  fetchPypi,
  markdown,
  isPy27,
}:

buildPythonPackage rec {
  pname = "python-markdown-math";
  version = "0.9";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VnOVVT3ElB55s3iaEJbcq7P9qVOdFQ1VjvNQeUiyZKM=";
  };

  nativeCheckInputs = [ markdown ];

  meta = {
    description = "Math extension for Python-Markdown";
    homepage = "https://github.com/mitya57/python-markdown-math";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ klntsky ];
  };
}
