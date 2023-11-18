{ lib
, buildPythonPackage
, fetchFromGitHub
, pydantic
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pydantic-scim";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chalk-ai";
    repo = "pydantic-scim";
    rev = "refs/tags/v${version}";
    hash = "sha256-Hbc94v/+slXRGDKKbMui8WPwn28/1XcKvHkbLebWtj0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version=get_version(),' 'version="${version}",'
  '';

  propagatedBuildInputs = [
    pydantic
  ] ++ pydantic.optional-dependencies.email;

  pythonImportsCheck = [
    "pydanticscim"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Pydantic types for SCIM";
    homepage = "https://github.com/chalk-ai/pydantic-scim";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
