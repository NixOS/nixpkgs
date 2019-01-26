{ stdenv
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "hetzner";
  version = "0.8.1";

  src = fetchFromGitHub {
    repo = "hetzner";
    owner = "aszlig";
    rev = "v${version}";
    sha256 = "1xd1klvjskv0pg8ginih597jkk491a55b8dq80dsm61m5sbsx3vq";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/RedMoonStudios/hetzner";
    description = "High-level Python API for accessing the Hetzner robot";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aszlig ];
  };

}
