{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, flit-core
, pythonOlder
, py-cid
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "pytest-cid";
  version = "1.1.1";
  format = "pyproject";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ntninja";
    repo = pname;
    rev = "1ff9ec43ac9eaf76352ea7e7a060cd081cb8b68a"; # Version has no git tag
    hash = "sha256-H2RtMGYWukowTTfqZSx+hikxzkqw1v5bA4AfZfiVl8U=";
  };

  patches = [
    # https://github.com/ntninja/pytest-cid/pull/2
    (fetchpatch {
      name = "replace-flit-with-flit-core.patch";
      url = "https://github.com/ntninja/pytest-cid/commit/f4a24a28d7893d3a0232d7745f14282609120b14.patch";
      hash = "sha256-1T+VsUXJ68YHTpxZYPcI2jfiRGoc/JBZwVEOm8ajvmE=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "pytest >= 5.0, < 7.0" "pytest >= 5.0"
  '';

  nativeBuildInputs = [
    flit-core
  ];

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
