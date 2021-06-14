{ lib, stdenv, fetchFromGitHub, python2, python3 }:

stdenv.mkDerivation rec {
  pname = "py3c";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "encukou";
    repo = pname;
    rev = "v${version}";
    sha256 = "04i2z7hrig78clc59q3i1z2hh24g7z1bfvxznlzxv00d4s57nhpi";
  };

  postPatch = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace test/setup.py \
      --replace "'-Werror', " ""
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  doCheck = true;

  checkInputs = [
    python2
    python3
  ];

  meta = with lib; {
    homepage = "https://github.com/encukou/py3c";
    description = "Python 2/3 compatibility layer for C extensions";
    license = licenses.mit;
    maintainers = with maintainers; [ ajs124 dotlambda ];
  };
}
