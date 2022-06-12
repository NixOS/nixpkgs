{ lib
, stdenv
, python
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, file
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-magic";
  version = "0.4.26";

  src = fetchFromGitHub {
    owner = "ahupp";
    repo = "python-magic";
    rev = version;
    sha256 = "sha256-RcKldMwSRroNZNEl0jwuJG9C+3OIPBzk+CjqkxKK/eY=";
  };

  patches = [
    (substituteAll {
      src = ./libmagic-path.patch;
      libmagic = "${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  preCheck = ''
    export LC_ALL=en_US.UTF-8
  '';

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A python interface to the libmagic file type identification library";
    homepage = "https://github.com/ahupp/python-magic";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
