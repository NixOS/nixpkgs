{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "dictpath";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "dictpath";
    rev = version;
    sha256 = "0314i8wky2z83a66zggc53m8qa1rjgkrznrl2ixsgiq0prcn6v16";
  };

  postPatch = ''
    sed -i "/^addopts/d" setup.cfg
  '';

  checkInputs = [
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
