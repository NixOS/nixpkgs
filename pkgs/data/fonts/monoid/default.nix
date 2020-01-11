{ stdenv, fetchFromGitHub, python2 }:
# Python 3 support requires https://github.com/larsenwork/monoid/pull/233 to be merged

stdenv.mkDerivation {
  pname = "monoid";
  version = "2016-07-21";

  src = fetchFromGitHub {
    owner = "larsenwork";
    repo = "monoid";
    rev = "e9d77ec18c337dc78ceae787a673328615f0b120";
    sha256 = "07h5q6cn6jjpmxp9vyag1bxx481waz344sr2kfs7d37bba8yjydj";
  };

  nativeBuildInputs = [
    (python2.withPackages (pp: with pp; [
      fontforge
    ]))
  ];

  buildPhase = ''
    local _d=""
    local _l=""
    for _d in {Monoisome,Source}/*.sfdir; do
      _l="''${_d##*/}.log"
      echo "Building $_d (log at $_l)"
      python Scripts/build.py 1 0 $_d > $_l
    done
  '';

  installPhase = ''
    install -m444 -Dt $out/share/fonts/truetype _release/*
    install -m444 -Dt $out/share/doc            Readme.md
  '';

  meta = with stdenv.lib; {
    homepage = http://larsenwork.com/monoid;
    description = "Customisable coding font with alternates, ligatures and contextual positioning";
    license = [ licenses.ofl licenses.mit ];
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
