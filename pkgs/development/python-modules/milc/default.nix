{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, appdirs
, argcomplete
, colorama
, gnugrep
}:

buildPythonPackage rec {
  pname = "milc";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "clueboard";
    repo = "milc";
    rev = version;
    sha256 = "04mk057b6jh0k4maqkg80kpilxak9r7vlr9xqwzczh2gs3g2x573";
  };

  checkInputs = [ gnugrep ];
  propagatedBuildInputs = [ appdirs argcomplete colorama ];

  # Upstream has a nose2 test suite that runs this hello script in a handful of
  # ways, but it's not in setup.py and makes assumptions about relative paths in
  # the src repo, so just sanity-check basic functionality.
  checkPhase = ''
    patchShebangs ./hello
    ./hello | grep "Hello, World"
  '';

  meta = with lib; {
    description = "An Opinionated Batteries-Included Python 3 CLI Framework";
    homepage = "https://milc.clueboard.co";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
