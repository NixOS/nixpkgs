{ lib
, buildPythonPackage
, fetchFromGitHub
, pydantic
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pydantic-scim";
  version = "0.0.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "chalk-ai";
    repo = "pydantic-scim";
    rev = "refs/tags/v${version}";
    hash = "sha256-F+uj7kSz6iSb0Vg00VfJ5GcxghooNDKa75S/ZgU7WgI=";
  };

  nativeBuildInputs = [
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
