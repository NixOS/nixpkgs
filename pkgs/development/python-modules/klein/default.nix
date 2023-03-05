{ lib
, stdenv
, attrs
, buildPythonPackage
, fetchFromGitHub
, hyperlink
, hypothesis
, incremental
, python
, pythonOlder
, treq
, tubes
, twisted
, typing-extensions
, werkzeug
, zope_interface
}:

buildPythonPackage rec {
  pname = "klein";
  version = "unstable-2022-12-05";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "twisted";
    repo = pname;
    rev = "022a25adc2056aa9c09ad352c42d381a04f7401a";
    hash = "sha256-Vyak26f9MX2v8hLUzKcVqXWoVRUP6UlgF5gYlwA0Yxs=";
  };

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

  # twisted.trial command hangs also all tests succceeds.
  # so we just stop after the testsuite finishes..
  checkPhase = ''
    while read line; do
        echo "$line"
        if echo "$line" | grep -Eq 'PASSED \(successes=[0-9]+\)'; then
            break
        fi
    done < <(${python.interpreter} -m twisted.trial -j $NIX_BUILD_CORES klein)
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
