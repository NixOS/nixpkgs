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
  version = "unstable-2022-06-26";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "twisted";
    repo = pname;
    rev = "d8c2b92a3c77aa64c596696fb6f07172ecf94a74";
    hash = "sha256-RDZqavkteUbARV78OctZtLIrE4RoYDVAanjwE5i/ZeM=";
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

  checkInputs = [
    hypothesis
    treq
  ];

  checkPhase = ''
    ${python.interpreter} -m twisted.trial -j $NIX_BUILD_CORES klein
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
