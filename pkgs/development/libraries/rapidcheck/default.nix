{ lib
, stdenv
, fetchFromGitHub
, cmake
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "rapidcheck";
  version = "unstable-2023-04-16";

  src = fetchFromGitHub {
    owner = "emil-e";
    repo  = "rapidcheck";
    rev   = "a5724ea5b0b00147109b0605c377f1e54c353ba2";
    hash = "sha256-nq2VBDREkAOnvtdYr3m0TYNXx7mv9hbV5HZFVL2uTTg=";
  };

  nativeBuildInputs = [ cmake ];

  # Install the extras headers
  postInstall = ''
    cp -r $src/extras $out
    chmod -R +w $out/extras
    rm $out/extras/CMakeLists.txt
    rm $out/extras/**/CMakeLists.txt
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A C++ framework for property based testing inspired by QuickCheck";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
