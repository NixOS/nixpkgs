{ lib
, buildPythonPackage
, fetchPypi
, markdown
, isPy27
}:

buildPythonPackage rec {
  pname = "python-markdown-math";
  version = "0.7";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "17a12175e8b2052a1c3402fca410841c551c678046293b1f7c280ccfe7b302a0";
  };

  checkInputs = [ markdown ];

  meta = {
    description = "Math extension for Python-Markdown";
    homepage = "https://github.com/mitya57/python-markdown-math";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ klntsky ];
  };
}
