{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
    hash = "sha256-fZ+5xJ3P0EYK+6rQ8VzXv2zckKfEH5VUdISIR6ybIfQ=";
  };

  patches = [
    (substituteAll {
      src = ./libmagic-path.patch;
      libmagic = "${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
    (fetchpatch {
      name = "update-test-for-upstream-added-gzip-extensions.patch";
      url = "https://github.com/ahupp/python-magic/commit/4ffcd59113fa26d7c2e9d5897b1eef919fd4b457.patch";
      hash = "sha256-67GpjlGiR4/os/iZ69V+ZziVLpjmid+7t+gQ2aQy9I0=";
    })
  ];

  preCheck = ''
    export LC_ALL=en_US.UTF-8
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A python interface to the libmagic file type identification library";
    homepage = "https://github.com/ahupp/python-magic";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
