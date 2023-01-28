{ lib
, buildPythonPackage
, fetchPypi
, markdown
, isPy27
}:

buildPythonPackage rec {
  pname = "python-markdown-math";
  version = "0.8";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8564212af679fc18d53f38681f16080fcd3d186073f23825c7ce86fadd3e3635";
  };

  nativeCheckInputs = [ markdown ];

  meta = {
    description = "Math extension for Python-Markdown";
    homepage = "https://github.com/mitya57/python-markdown-math";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ klntsky ];
  };
}
