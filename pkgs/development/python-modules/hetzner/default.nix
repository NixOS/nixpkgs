{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "hetzner";
  version = "0.8.3";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "hetzner";
    owner = "aszlig";
    rev = "v${version}";
    sha256 = "0nhm7j2y4rgmrl0c1rklg982qllp7fky34dchqwd4czbsdnv9j7a";
  };

  meta = with lib; {
    homepage = "https://github.com/RedMoonStudios/hetzner";
    description = "High-level Python API for accessing the Hetzner robot";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aszlig ];
  };
}
