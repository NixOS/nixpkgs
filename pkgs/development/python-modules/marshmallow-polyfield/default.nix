{ lib
, buildPythonPackage
, fetchFromGitHub
, marshmallow
, pythonOlder
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "marshmallow-polyfield";
  version = "5.10";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Bachmann1234";
    repo = "marshmallow-polyfield";
    rev = "refs/tags/v${version}";
    hash = "sha256-oF5LBuDK4kqsAcKwidju+wFjigjy4CNbJ6bfWpGO1yQ=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=marshmallow_polyfield" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    marshmallow
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "marshmallow"
  ];

  meta = with lib; {
    description = "Extension to Marshmallow to allow for polymorphic fields";
    homepage = "https://github.com/Bachmann1234/marshmallow-polyfield";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
