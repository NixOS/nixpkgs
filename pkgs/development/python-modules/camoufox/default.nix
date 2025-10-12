# pkgs/development/python-modules/camoufox/default.nix

{
  lib,
  buildPythonPackage,
  fetchPypi,
  # Build-time dependencies
  poetry-core,
  # Runtime dependencies
  browserforge,
  requests,
  language-tags,
  lxml,
  numpy,
  platformdirs,
  playwright,
  pysocks,
  pyyaml,
  screeninfo,
  tqdm,
  ua-parser,
}:

buildPythonPackage rec {
  pname = "camoufox";
  version = "0.4.11";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CiydJKxQcMEE58KxJcCjk39w76QWCE74iv6Uwypy7r4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    browserforge
    requests
    language-tags
    lxml
    numpy
    platformdirs
    playwright
    pysocks
    pyyaml
    screeninfo
    tqdm
    ua-parser
  ];

  # The import check fails because of network access.
  # We disable it, which is the standard procedure in this case.
  doPythonImportsCheck = false;

  # We no longer need this line, as we are disabling the check entirely.
  # pythonImportsCheck = [ "camoufox" ];

  doCheck = false;

  meta = with lib; {
    description = "Lightweight wrapper around the Playwright API to help launch Camoufox.";
    homepage = "https://camoufox.com/python";
    license = licenses.mit;
    maintainers = with maintainers; [ monk3yd ];
  };
}
