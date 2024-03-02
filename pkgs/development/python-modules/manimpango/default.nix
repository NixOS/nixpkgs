{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, pkg-config
, pango
, cython
, AppKit
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "manimpango";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ManimCommunity";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-EBSbvjQyQIXOzvQMbuTwOoV8xSAOYDlCBZ56NLneuQI=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pango
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
  ];

  propagatedBuildInputs = [
    cython
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov --no-cov-on-fail" ""
  '';

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} setup.py build_ext --inplace
  '';

  pythonImportsCheck = [
    "manimpango"
  ];

  meta = with lib; {
    description = "Binding for Pango";
    homepage = "https://github.com/ManimCommunity/ManimPango";
    changelog = "https://github.com/ManimCommunity/ManimPango/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
  };
}
