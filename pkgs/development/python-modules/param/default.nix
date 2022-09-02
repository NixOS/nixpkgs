{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-NrMsIDcpZc/R2j8VuXitbnIlhP3NtLxU/OkygXqYok8=";
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
