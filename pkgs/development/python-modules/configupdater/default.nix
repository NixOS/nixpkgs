{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "configupdater";
  version = "3.1.1";

  src = fetchPypi {
    inherit version;
    pname = "ConfigUpdater";
    sha256 = "sha256-RvDHTXPvpyN3Z2S0PJc59oBSSV3T1zQxnB0OtYUR8Vs=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace '--cov configupdater --cov-report term-missing' ""
  '';

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [ "configupdater" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Parser like ConfigParser but for updating configuration files";
    homepage = "https://configupdater.readthedocs.io/en/latest/";
    license = with licenses; [ mit psfl ];
    maintainers = with maintainers; [ ris ];
  };
}
