{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest,
  pytestCheckHook,
  pytest-describe,
}:

buildPythonPackage {
  pname = "pytest-spec";
  version = "3.2.0-unstable-2023-06-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pchomik";
    repo = "pytest-spec";
    rev = "e16e0550dd6bc557411e4312b7b42d53b26e69ef";
    hash = "sha256-dyDUdZJU4E4y1yCzunAX2c48Qv6ogu0b60U/5YbJvIU=";
  };

  postPatch = ''
    sed -i '/addopts/d' setup.cfg
    # TODO: upstream
    substituteInPlace pyproject.toml \
        --replace-fail "poetry>=0.12" "poetry-core" \
        --replace-fail "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [ poetry-core ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-describe
  ];

  pytestFlagsArray = [ "--spec" ];

  pythonImportsCheck = [ "pytest_spec" ];

  meta = {
    description = "Pytest plugin to display test execution output like a SPECIFICATION";
    homepage = "https://github.com/pchomik/pytest-spec";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
