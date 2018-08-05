{ stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "libbraiding-${version}";

  src = fetchFromGitHub {
    owner = "miguelmarco";
    repo = "libbraiding";
    rev = version;
    sha256 = "0l68rikfr7k2l547gb3pp3g8cj5zzxwipm79xrb5r8ffj466ydxg";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  # no tests included for now (2018-08-05), but can't hurt to activate
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/miguelmarco/libbraiding/;
    description = "C++ library for computations on braid groups";
    longDescription = ''
      A library to compute several properties of braids, including centralizer and conjugacy check.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.all;
  };
}
