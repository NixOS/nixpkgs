{ lib
, buildPythonPackage
, fetchFromGitHub
, marshmallow
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "marshmallow-polyfield";
  version = "5.10";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Bachmann1234";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oF5LBuDK4kqsAcKwidju+wFjigjy4CNbJ6bfWpGO1yQ=";
  };

  propagatedBuildInputs = [
    marshmallow
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=marshmallow_polyfield" ""
  '';

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
