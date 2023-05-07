{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook
, regex
, pytestCheckHook
, pytest-cov
, pytest-forked
, pytest-random-order
, pytest-socket
, pytest-sugar
}:

buildPythonPackage rec {
  pname = "oelint-parser";
  version = "2.10.5";

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = pname;
    rev = version;
    hash = "sha256-gB4+oo3zcOLK4M7hIOalxp13g18qRtN4iPwPGcly920=";
  };

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = true;

  propagatedBuildInputs = [ regex ];

  checkInputs = [
    pytest-cov
    pytest-forked
    pytest-random-order
    pytest-socket
    pytest-sugar
    pytestCheckHook
  ];

  pythonImportsCheck = [ "oelint_parser" ];

  meta = with lib; {
    description = "Alternative parser for bitbake recipes";
    homepage = "https://github.com/priv-kweihmann/oelint-parser";
    changelog = "https://github.com/priv-kweihmann/oelint-parser/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ christoph-heiss ];
  };
}
