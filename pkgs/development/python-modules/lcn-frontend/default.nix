{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lcn-frontend";
  version = "0.2.4";
  pyproject = true;

  src = fetchPypi {
    pname = "lcn_frontend";
    inherit version;
    hash = "sha256-pjpzOUhNCEYncCk+u/1u5gXot+5rEAvSfdL21fO6LMY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=68.0" setuptools \
      --replace-fail "wheel~=0.40.0" wheel
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "lcn_frontend" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/alengwenus/lcn-frontend/releases/tag/${version}";
    description = "LCN panel for Home Assistant";
    homepage = "https://github.com/alengwenus/lcn-frontend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
