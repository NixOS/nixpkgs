{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, hyperlink
, hypothesis
, incremental
, python
, pythonOlder
, setuptools
, treq
, tubes
, twisted
, typing-extensions
, werkzeug
, wheel
, zope_interface
}:

buildPythonPackage rec {
  pname = "klein";
  version = "23.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "twisted";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-2oU1HGBkBXjrpMvsiHgbAJ4M/5650ZjJkwo/Yk4nz3I=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    attrs
    hyperlink
    incremental
    twisted
    tubes
    werkzeug
    zope_interface
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    hypothesis
    treq
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m twisted.trial klein

    runHook postCheck
  '';

  pythonImportsCheck = [
    "klein"
  ];

  meta = with lib; {
    description = "Klein Web Micro-Framework";
    homepage = "https://github.com/twisted/klein";
    license = licenses.mit;
    maintainers = with maintainers; [ exarkun ];
  };
}
