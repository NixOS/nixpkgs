{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  flit-core,
  py-cid,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "pytest-cid";
  version = "1.1.2";
  format = "pyproject";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ntninja";
    repo = "pytest-cid";
    tag = "v${version}";
    hash = "sha256-dcL/i5+scmdXh7lfE8+32w9PdHWf+mkunJL1vpJ5+Co=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "pytest >= 5.0, < 7.0" "pytest >= 5.0"
  '';

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ py-cid ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pytest_cid" ];

  meta = with lib; {
    homepage = "https://github.com/ntninja/pytest-cid";
    description = "Simple wrapper around py-cid for easily writing tests involving CIDs in datastructures";
    license = licenses.mpl20;
    maintainers = with maintainers; [ Luflosi ];
  };
}
