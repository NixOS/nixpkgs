{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dictpath";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "dictpath";
    rev = version;
    sha256 = "sha256-3qekweG+o7f6nm1cnCEHrWYn/fQ42GZrZkPwGbZcU38=";
  };

  postPatch = ''
    sed -i "/^addopts/d" setup.cfg
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dictpath" ];

  meta = with lib; {
    description = "Object-oriented dictionary paths";
    homepage = "https://github.com/p1c2u/dictpath";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
