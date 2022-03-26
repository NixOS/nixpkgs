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
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ManimCommunity";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ourSUYBAFONdupdsjo/PtwRQpXS7HqLxrHj0Ejr/Wdw=";
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

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov --no-cov-on-fail" ""
  '';

  preBuild = ''
    ${python.interpreter} setup.py build_ext --inplace
  '';

  pythonImportsCheck = [
    "manimpango"
  ];

  meta = with lib; {
    description = "Binding for Pango";
    homepage = "https://github.com/ManimCommunity/ManimPango";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
  };
}
