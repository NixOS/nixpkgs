{ stdenv, fetchFromGitHub, fetchpatch, python3 }:

stdenv.mkDerivation {
  pname = "monoid";
  version = "2018-06-03";

  src = fetchFromGitHub {
    owner = "larsenwork";
    repo = "monoid";
    rev = "a331c7c5f402c449f623e0d0895bd2fd8dc30ccf";
    sha256 = "sha256-RV6lxv5CjywTMcuPMj6rdjLKrap7zLJ7niaNeF//U1Y=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/larsenwork/monoid/pull/233/commits/f84f2ed61301ee84dadd16351314394f22ebed2f.patch";
      sha256 = "sha256-CxfFHlR7TB64pvrfzVfUDkPwuRO2UdGOhXwW98c+oQU=";
    })
  ];

  nativeBuildInputs = [
    (python3.withPackages (pp: with pp; [
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
    homepage = "http://larsenwork.com/monoid";
    description = "Customisable coding font with alternates, ligatures and contextual positioning";
    license = [ licenses.ofl licenses.mit ];
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
