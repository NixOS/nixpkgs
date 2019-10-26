{ fetchPypi
, lib
, buildPythonPackage
, attrs
, click
, effect
, jinja2
}:

buildPythonPackage rec {
  pname = "nix-prefetch-github";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jkvmj33xinff0sb47yg33n131yi93pyq86skqc78xd38j6c8q9s";
  };

  propagatedBuildInputs = [
    attrs
    click
    effect
    jinja2
  ];

  meta = with lib; {
    description = "Prefetch sources from github";
    homepage = https://github.com/seppeljordan/nix-prefetch-github;
    license = licenses.gpl3;
    maintainers = with maintainers; [ seppeljordan ];
  };
}
