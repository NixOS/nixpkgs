{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, invoke
, mock
, paramiko
, pytestCheckHook
, pytest-relaxed
}:

buildPythonPackage rec {
  pname = "fabric";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dvj+9ZzyBh29hJu85P5JvdggiEOFAEsMpZE2rD2xKeQ=";
  };

  # only relevant to python < 3.4
  postPatch = ''
    substituteInPlace setup.py \
        --replace ', "pathlib2"' ' '
  '';

  propagatedBuildInputs = [ invoke paramiko cryptography ];

  nativeCheckInputs = [ pytestCheckHook pytest-relaxed mock ];

  # ==================================== ERRORS ====================================
  # ________________________ ERROR collecting test session _________________________
  # Direct construction of SpecModule has been deprecated, please use SpecModule.from_parent
  # See https://docs.pytest.org/en/stable/deprecations.html#node-construction-changed-to-node-from-parent for more details.
  doCheck = false;

  pythonImportsCheck = [ "fabric" ];

  meta = with lib; {
    description = "Pythonic remote execution";
    homepage = "https://www.fabfile.org/";
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
