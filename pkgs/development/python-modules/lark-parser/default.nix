{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "1mjicdvrzh9r9q3xrjrzaiaxk04r60a3l6l0vnp1hq3xfc9ccqc8";
  };

  # tests of Nearley support require js2py
  preCheck = ''
    rm -r tests/test_nearley
  '';

  meta = {
    description = "A modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = https://github.com/lark-parser/lark;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
