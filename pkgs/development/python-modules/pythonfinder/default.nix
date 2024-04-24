{ lib
, buildPythonPackage
, cached-property
, click
, fetchFromGitHub
, fetchpatch
, packaging
, pydantic
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pythonfinder";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-CbaKXD7Sde8euRqvc/IHoXoSMF+dNd7vT9LkLWq4/IU=";
  };

  patches = [
    # https://github.com/sarugaku/pythonfinder/issues/142
    (fetchpatch {
      name = "pydantic_2-compatibility.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/python-pythonfinder/-/raw/2.0.6-1/python-pythonfinder-2.0.6-pydantic2.patch";
      hash = "sha256-mON1MeA+pj6VTB3zpBjF3LfB30wG0QH9nU4bD1djWwg=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    packaging
    pydantic
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
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
    mainProgram = "pyfinder";
    homepage = "https://github.com/sarugaku/pythonfinder";
    changelog = "https://github.com/sarugaku/pythonfinder/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
