{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "asgineer";
  version = "0.8.1";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hd1i9pc8m7sc8bkn31q4ygkmnl5vklrcziq9zkdiqaqm8clyhcx";
  };

  doCheck = false;

  meta = with lib; {
    description = "A really thin ASGI web framework";
    license = licenses.bsd2;
    homepage = "https://asgineer.readthedocs.io";
    maintainers = [ maintainers.matthiasbeyer ];
  };
}

