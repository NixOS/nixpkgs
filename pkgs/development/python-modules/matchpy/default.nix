{ lib
, buildPythonPackage
, fetchFromGitHub
, hopcroftkarp
, multiset
, pytestCheckHook
, hypothesis
, setuptools-scm
, isPy27
}:

buildPythonPackage rec {
  pname = "matchpy";
  version = "0.5.5"; # Don't upgrade to 4.3.1, this tag is very old
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "HPAC";
    repo = pname;
    rev = version;
    hash = "sha256-n5rXIjqVQZzEbfIZVQiGLh2PR1DHAJ9gumcrbvwnasA=";
  };

  postPatch = ''
    sed -i '/pytest-runner/d' setup.cfg

    substituteInPlace setup.cfg \
      --replace "multiset>=2.0,<3.0" "multiset"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    hopcroftkarp
    multiset
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [
    "matchpy"
  ];

  meta = with lib; {
    description = "A library for pattern matching on symbolic expressions";
    homepage = "https://github.com/HPAC/matchpy";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
