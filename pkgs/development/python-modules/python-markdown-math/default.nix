{ lib
, buildPythonPackage
, fetchPypi
, markdown
}:

buildPythonPackage rec {
  pname = "python-markdown-math";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c68d8cb9695cb7b435484403dc18941d1bad0ff148e4166d9417046a0d5d3022";
  };

  checkInputs = [ markdown ];

  meta = {
    description = "Math extension for Python-Markdown";
    homepage = https://github.com/mitya57/python-markdown-math;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ klntsky ];
  };
}
