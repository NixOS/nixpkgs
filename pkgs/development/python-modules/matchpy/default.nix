{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  hopcroftkarp,
  multiset,
  pytestCheckHook,
  hypothesis,
  setuptools-scm,
  isPy27,
}:

buildPythonPackage rec {
  pname = "matchpy";
  version = "0.5.5"; # Don't upgrade to 4.3.1, this tag is very old
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "HPAC";
    repo = "matchpy";
    rev = version;
    hash = "sha256-n5rXIjqVQZzEbfIZVQiGLh2PR1DHAJ9gumcrbvwnasA=";
  };

  patches = [
    # https://github.com/HPAC/matchpy/pull/77
    (fetchpatch {
      name = "fix-versioneer-py312.patch";
      url = "https://github.com/HPAC/matchpy/commit/965d7c39689b9f2473a78ed06b83f2be701e234d.patch";
      hash = "sha256-xXADCSIhq1ARny2twzrhR1J8LkMFWFl6tmGxrM8RvkU=";
    })
  ];

  postPatch = ''
    sed -i '/pytest-runner/d' setup.cfg

    substituteInPlace setup.cfg \
      --replace "multiset>=2.0,<3.0" "multiset"
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    hopcroftkarp
    multiset
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "matchpy" ];

  meta = with lib; {
    description = "Library for pattern matching on symbolic expressions";
    homepage = "https://github.com/HPAC/matchpy";
    license = licenses.mit;
    maintainers = [ ];
  };
}
