{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, alarmdecoder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "adext";
  version = "0.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ajschmidt8";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h5k9kzms2f0r48pdhsgv8pimk0vsxw8vs0k6880mank8ij914wr";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    alarmdecoder
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "adext" ];

  meta = with lib; {
    description = "Python extension for AlarmDecoder";
    homepage = "https://github.com/ajschmidt8/adext";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
