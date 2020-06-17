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
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PVB/cL0NVB5pHxRMjg8TLatvIvHjfCvaRWBanVHYT+E=";
  };

  # The tests for this package require nix and network access.  That's
  # why we cannot execute them inside the building process.
  doCheck = false;

  propagatedBuildInputs = [
    attrs
    click
    effect
    jinja2
  ];

  meta = with lib; {
    description = "Prefetch sources from github";
    homepage = "https://github.com/seppeljordan/nix-prefetch-github";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seppeljordan ];
  };
}
