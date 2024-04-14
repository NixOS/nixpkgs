{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "reparser";
  version = "1.4.3";
  format = "setuptools";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "xmikos";
    repo = "reparser";
    rev = "v${version}";
    sha256 = "04v7h52wny0j2qj37501nk33j0s4amm134kagdicx2is49zylzq1";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "reparser" ];

  meta = with lib; {
    description = "Simple regex-based lexer/parser for inline markup";
    homepage = "https://github.com/xmikos/reparser";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
