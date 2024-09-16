{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "prayer-times-calculator-offline";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpfair";
    repo = "prayer-times-calculator-offline";
    rev = "refs/tags/v${version}";
    hash = "sha256-sVEdjtwxwGa354YimeaNqjqZ9yEecNXg8kk6Pafvvd4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "prayer_times_calculator_offline" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/cpfair/prayer-times-calculator-offline/releases/tag/v${version}";
    description = "Prayer Times Calculator - Offline";
    homepage = "https://github.com/cpfair/prayer-times-calculator-offline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
