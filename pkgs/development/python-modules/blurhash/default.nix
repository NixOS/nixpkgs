{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pillow
, numpy
}:

buildPythonPackage rec {
  pname = "blurhash";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "halcy";
    repo = "blurhash-python";
    # There are no tags: https://github.com/halcy/blurhash-python/issues/4
    rev = "22e081ef1c24da1bb5c5eaa2c1d6649724deaef8";
    sha256 = "1qq6mhydlp7q3na4kmaq3871h43wh3pyfyxr4b79bia73wjdylxf";
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pillow
    numpy
  ];

  pythonImportsCheck = [ "blurhash" ];

  meta = with lib; {
    description = "Pure-Python implementation of the blurhash algorithm";
    homepage = "https://github.com/halcy/blurhash-python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
