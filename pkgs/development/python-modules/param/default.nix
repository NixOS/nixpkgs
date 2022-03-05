{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = pname;
    rev = "v${version}";
    sha256 = "02zmd4bwyn8b4q1l9jgddc70ii1i7bmynacanl1cvbr6la4v9b2c";
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
