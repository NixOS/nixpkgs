{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cython
, gcc
, click
}:

buildPythonPackage rec {
  pname = "primer3";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "libnano";
    repo = "primer3-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ku2PVrWYWPKnNXeUQmstQedJg1O0hsQl4/iEnAMMEaY=";
  };

  nativeBuildInputs = [ cython ]
    ++ lib.optionals stdenv.isDarwin [ gcc ];

  # pytestCheckHook leads to a circular import issue
  nativeCheckInputs = [ click ];

  pythonImportsCheck = [ "primer3" ];

  meta = with lib; {
    description = "Oligo analysis and primer design";
    homepage = "https://github.com/libnano/primer3-py";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
