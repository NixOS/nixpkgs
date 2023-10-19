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
  version = "0.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ManimCommunity";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-M7Wd4s9q+oNioi4JlcQcKSyLRliGgoMzkiXcIznpR5o=";
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
    ${python.pythonForBuild.interpreter} setup.py build_ext --inplace
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
