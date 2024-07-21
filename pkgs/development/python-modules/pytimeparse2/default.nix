{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  dateutils,
}:

buildPythonPackage rec {
  pname = "pytimeparse2";
  version = "1.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "onegreyonewhite";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zWRbSohTvbVd3GcRRoxH/UReVGYHC0YmbNgbt8N0X48=";
  };

  propagatedBuildInputs = [ dateutils ];

  # custom checks, see
  # https://github.com/onegreyonewhite/pytimeparse2/blob/e00df7506b6925f2c6a5783e89e9f239d128271a/tox.ini#L36C20-L36C78
  checkPhase = ''
    runHook preCheck
    python tests.py -vv --failfast
    runHook postCheck
  '';

  pythonImportsCheck = [ "pytimeparse2" ];

  meta = with lib; {
    description = "Pytimeparse based project with the aim of optimizing functionality and providing stable support";
    homepage = "https://github.com/onegreyonewhite/pytimeparse2";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
