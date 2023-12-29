{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, decorator
, invoke
, mock
, paramiko
, pytestCheckHook
, pytest-relaxed
}:

buildPythonPackage rec {
  pname = "fabric";
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h4PKQuOwB28IsmkBqsa52bHxnEEAdOesz6uQLBhP9KM=";
  };

  # only relevant to python < 3.4
  postPatch = ''
    substituteInPlace setup.py \
        --replace ', "pathlib2"' ' '
  '';

  propagatedBuildInputs = [ invoke paramiko cryptography decorator ];

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
    maintainers = [ ];
  };
}
