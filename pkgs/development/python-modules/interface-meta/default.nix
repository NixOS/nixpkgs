{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "interface-meta";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "matthewwardrop";
    repo = "interface_meta";
    rev = "refs/tags/v${version}";
    hash = "sha256-DSL1cS0sz1epIZaLsISwnVnkrBdshzRCWGMsZXkI8Gc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml  \
      --replace 'version = "0.0.0"' 'version = "${version}"'
  '';

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "interface_meta"
  ];

  meta = with lib; {
    description = "Convenient way to expose an extensible API with enforced method signatures and convenient documentation";
    homepage = "https://github.com/matthewwardrop/interface_meta";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
