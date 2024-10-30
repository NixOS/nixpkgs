{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  version = "1.3";
  pname = "libbraiding";

  src = fetchFromGitHub {
    owner = "miguelmarco";
    repo = "libbraiding";
    rev = version;
    sha256 = "sha256-JZKNM9qsyAyNiayx4xllf3QNNS7JrKSybBwERy4FvNI=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  # no tests included for now (2018-08-05), but can't hurt to activate
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/miguelmarco/libbraiding/";
    description = "C++ library for computations on braid groups";
    longDescription = ''
      A library to compute several properties of braids, including centralizer and conjugacy check.
    '';
    license = licenses.gpl3;
    maintainers = teams.sage.members;
    platforms = platforms.all;
  };
}
