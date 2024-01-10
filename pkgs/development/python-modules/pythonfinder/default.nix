{ lib
, buildPythonPackage
, cached-property
, click
, fetchFromGitHub
, packaging
, pydantic
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pythonfinder";
  version = "2.0.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-L/+6w5lLqHO5c9CThoUPOHXRPVxBlOWFDAmfoYxRw5g=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cached-property
    packaging
    pydantic
  ];

  passthru.optional-dependencies = {
    cli = [
      click
    ];
  };

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "pythonfinder"
  ];

  # these tests invoke git in a subprocess and
  # for some reason git can't be found even if included in nativeCheckInputs
  # disabledTests = [
  #   "test_shims_are_kept"
  #   "test_shims_are_removed"
  # ];

  meta = with lib; {
    description = "Cross platform search tool for finding Python";
    homepage = "https://github.com/sarugaku/pythonfinder";
    changelog = "https://github.com/sarugaku/pythonfinder/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
