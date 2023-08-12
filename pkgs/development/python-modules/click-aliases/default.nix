{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-aliases";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-aliases";
    rev = "v${version}";
    hash = "sha256-vzWlCb4m9TdRaVz4DrlRRZ60+9gj60NoiALgvaIG0gA=";
  };

  patches = [
    ./0001-Fix-quotes-in-test.patch
  ];

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "click_aliases" ];

  meta = with lib; {
    homepage = "https://github.com/click-contrib/click-aliases";
    description = "Enable aliases for click";
    license = licenses.mit;
    maintainers = with maintainers; [ panicgh ];
  };
}
