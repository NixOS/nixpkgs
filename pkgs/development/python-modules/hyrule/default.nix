{ lib
, buildPythonPackage
, fetchFromGitHub
, hy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hyrule";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hylang";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-nQAUVX409RWlFPeknnNwFNgo7e2xHkEXkAuXazZNntk=";
  };

  propagatedBuildInputs = [
    hy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Some tests depends on hy on PATH
  preCheck = "PATH=${hy}/bin:$PATH";

  pythonImportsCheck = [ "hyrule" ];

  meta = with lib; {
    description = "Hyrule is a utility library for the Hy programming language";
    homepage = "https://github.com/hylang/hyrule";
    changelog = "https://github.com/hylang/hylure/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ thiagokokada ];
  };
}
