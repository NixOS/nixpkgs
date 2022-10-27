{ lib
, buildPythonPackage
, fetchFromGitHub
, hy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hyrule";
  version = "0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hylang";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-/YHgJq+C5+yc+44s76OR0WELUm8KHL2xxtJmGDTChCM=";
  };

  propagatedBuildInputs = [
    hy
  ];

  checkInputs = [
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
