{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, py-cid
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "pytest-cid";
  version = "1.1.1";
  format = "flit";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ntninja";
    repo = pname;
    rev = "1ff9ec43ac9eaf76352ea7e7a060cd081cb8b68a"; # Version has no git tag
    hash = "sha256-H2RtMGYWukowTTfqZSx+hikxzkqw1v5bA4AfZfiVl8U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "pytest >= 5.0, < 7.0" "pytest >= 5.0"
  '';

  propagatedBuildInputs = [
    py-cid
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "pytest_cid" ];

  meta = with lib; {
    homepage = "https://github.com/ntninja/pytest-cid";
    description = "A simple wrapper around py-cid for easily writing tests involving CIDs in datastructures";
    license = licenses.mpl20;
    maintainers = with maintainers; [ Luflosi ];
  };
}
