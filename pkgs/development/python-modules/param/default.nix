{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MehTz0qCpWe/11PZ5jmFxHE54TA+QX2KfqvKB8L79V4=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # Version is not set properly
    substituteInPlace setup.py \
      --replace 'version=get_setup_version("param"),' 'version="${version}",'
  '';

  pythonImportsCheck = [
    "param"
  ];

  meta = with lib; {
    description = "Declarative Python programming using Parameters";
    homepage = "https://github.com/pyviz/param";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
