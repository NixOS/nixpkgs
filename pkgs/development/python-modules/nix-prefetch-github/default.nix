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
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18xj618zjs13ib7f996fnl0xiqig0w48yns45nvy3xab55wximdx";
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
