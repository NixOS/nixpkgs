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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "libnano";
    repo = "primer3-py";
    rev = version;
    sha256 = "1glybwp9w2m1ydvaphr41gj31d8fvlh40s35galfbjqa563si72g";
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
