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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "libnano";
    repo = "primer3-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-o9B8TN3mOchOO7dz34mI3NDtIhHSlA9+lMNsYcxhTE0=";
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
