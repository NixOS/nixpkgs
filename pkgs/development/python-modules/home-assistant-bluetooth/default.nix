{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cython
, poetry-core
, setuptools
, bleak
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "home-assistant-bluetooth";
  version = "1.9.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8RGwWx/I6Log7qyGiP+LAWC1GCG2A7UEXnO5fGoTsb4=";
  };

  postPatch = ''
    # drop pytest parametrization (coverage, etc.)
    sed -i '/addopts/d' pyproject.toml
  '';

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    bleak
  ];

  pythonImportsCheck = [
    "home_assistant_bluetooth"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Basic bluetooth models used by Home Assistant";
    changelog = "https://github.com/home-assistant-libs/home-assistant-bluetooth/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/home-assistant-libs/home-assistant-bluetooth";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
