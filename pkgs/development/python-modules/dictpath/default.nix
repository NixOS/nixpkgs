{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "dictpath";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "dictpath";
    rev = "refs/tags/${version}";
    sha256 = "sha256-4QRFjbeaggoEPVGAmSY+qVMNW0DKqarNfRXaH6B58ew=";
  };

  postPatch = ''
    sed -i "/^addopts/d" setup.cfg
  '';

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "dictpath" ];

  meta = with lib; {
    description = "Object-oriented dictionary paths";
    homepage = "https://github.com/p1c2u/dictpath";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
