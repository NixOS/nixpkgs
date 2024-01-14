{ buildPythonPackage
, fetchFromGitHub
, lib
, pythonOlder
, setuptools

, # dependencies
  attrs
, babel
, fluent-syntax
, pytz
, typing-extensions
}:

buildPythonPackage rec {
  pname = "fluent-runtime";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "projectfluent";
    repo = "python-fluent";
    rev = "fluent.runtime@${version}";
    hash = "sha256-Crg6ybweOZ4B3WfLMOcD7+TxGEZPTHJUxr8ItLB4G+Y=";
  };

  setSourceRoot = "sourceRoot=$(echo */fluent.runtime)";

  propagatedBuildInputs = [
    attrs
    babel
    fluent-syntax
    pytz
    setuptools
    typing-extensions
  ];

  pythonImportsCheck = [
    "fluent.runtime"
  ];

  meta = with lib; {
    description = "Localization library for expressive translations";
    homepage = "https://projectfluent.org/python-fluent";
    downloadPage = "https://github.com/projectfluent/python-fluent/releases/tag/fluent.runtime@${version}";
    changelog = "https://github.com/projectfluent/python-fluent/blob/main/fluent.runtime/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ getpsyched ];
    platforms = platforms.all;
  };
}
