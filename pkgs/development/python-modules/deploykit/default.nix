{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, bash
, openssh
, pytestCheckHook
, stdenv
}:

buildPythonPackage rec {
  pname = "deploykit";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = pname;
    rev = version;
    hash = "sha256-eKyqsGgnJmF2wUYa7HjC1Jwsh03qVTJEP1MtL7JL4Ts=";
  };

  buildInputs = [
    setuptools
  ];

  checkInputs = [
    bash
    openssh
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [ "test_ssh" ];

  # don't swallow stdout/stderr
  pytestFlagsArray = [ "-s" ];

  meta = with lib; {
    description = "Execute commands remote via ssh and locally in parallel with python";
    homepage = "https://github.com/numtide/deploykit";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 zowoq ];
    platforms = platforms.unix;
  };
}
