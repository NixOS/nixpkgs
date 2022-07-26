{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cgreen";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "cgreen-devs";
    repo = "cgreen";
    rev = version;
    sha256 = "sha256-aQrfsiPuNrEMscZrOoONiN665KlNmnOiYj9ZIyzW304=";
  };

  postPatch = ''
    for F in tools/discoverer_acceptance_tests.c tools/discoverer.c; do
      substituteInPlace "$F" --replace "/usr/bin/nm" "nm"
    done
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/cgreen-devs/cgreen";
    description = "The Modern Unit Test and Mocking Framework for C and C++";
    license = licenses.isc;
    maintainers = [ maintainers.nichtsfrei ];
    platforms = platforms.unix;
  };
}
