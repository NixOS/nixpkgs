{ stdenv, fetchFromGitHub,
  buildPythonPackage, isPy34, isPy35,
  appdirs, requests, decorating
}:

buildPythonPackage rec {
  pname = "mal";
  version = "2018-03-01";

  # we have to use the git version because the latest version on PyPI, 0.3.2,
  # requires `decorating == 0.5.2` which fails to build
  src = fetchFromGitHub {
    owner  = "ryukinix";
    repo   = "mal";
    rev    = "4930bc69ed471691df90e9da8ccd41409f21f989";
    sha256 = "00l1vljzvhv4a42mljvl02dkn2jgjd19845c973hxc5m8p5c06xc";
  };

  propagatedBuildInputs = [ appdirs requests decorating ];

  # tests currently fail on Python 3.6, try adding isPy36 when the next version
  # after 0.3.2 is released
  disabled = !(isPy34 || isPy35);

  meta = with stdenv.lib; {
    description = "Command-line interface to the MyAnimeList API";
    homepage    = "https://github.com/ryukinix/mal";
    maintainers = [ maintainers.taktoa ];
    license     = licenses.gpl3Plus;
  };
}
