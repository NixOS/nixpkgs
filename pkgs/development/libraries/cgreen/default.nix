{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cgreen";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "cgreen-devs";
    repo = "cgreen";
    rev = version;
    sha256 = "sha256-BXch/V73a35Y6MqUlmR8mDp3ttwEAQTnqDC+ygLbIPY=";
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
