{ stdenv
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "hetzner";
  version = "0.8.2";

  src = fetchFromGitHub {
    repo = "hetzner";
    owner = "aszlig";
    rev = "v${version}";
    sha256 = "152fklxff08s71v0b78yp5ajwpqyszm3sd7j0qsrwa2x9ik4968h";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/RedMoonStudios/hetzner";
    description = "High-level Python API for accessing the Hetzner robot";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aszlig ];
  };
}
