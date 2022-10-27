{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, file
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-magic";
  version = "0.4.27";

  src = fetchFromGitHub {
    owner = "ahupp";
    repo = "python-magic";
    rev = version;
    sha256 = "sha256-fZ+5xJ3P0EYK+6rQ8VzXv2zckKfEH5VUdISIR6ybIfQ=";
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
