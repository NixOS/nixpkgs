{ buildPythonPackage
, fetchFromGitHub
, isPy3k
, stdenv
, attrs
, click
, effect
, jinja2
, requests
}:

buildPythonPackage rec {
  pname = "nix-prefetch-github";
  version = "1.3";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "${version}";
    sha256 = "1rinbv1q4q8m27ih6l81w1lsmwn6cz7q3iyjiycklywpi8684dh6";
  };

  propagatedBuildInputs = [
    attrs
    click
    effect
    jinja2
    requests
  ];
  meta = with stdenv.lib; {
    description = "Prefetch sources from github";
    homepage = https://github.com/seppeljordan/nix-prefetch-github;
    license = licenses.gpl3;
    maintainers = [ maintainers.seppeljordan ];
  };
}
