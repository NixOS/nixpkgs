{ buildPythonPackage
, fetchFromGitHub
, lib
, appdirs
, click
, decorator
, logzero
, lxml
, more-itertools
, mypy
, orjson
, pytestCheckHook
, pandas
, pytz
, setuptools-scm
, python3

, cachew
, orgparse
, influxdb
, geopy
, pillow
, simplejson
, browserexport
, gpxpy
, pdfannots
, google-takeout-parser
, GitPython
, pinbexport
, goodrexport
}:

buildPythonPackage rec {
  pname = "HPI";
  version = "0.3.20230207";

  src = fetchFromGitHub {
    owner = "karlicoss";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+7jy+JmCHw1Fqtn0DGlSO+XirBEKZHqA+9+Rm8ZaDbQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    cachew
    geopy
    influxdb
    orgparse
    pillow
    pytestCheckHook
    simplejson
    browserexport
    lxml
    mypy
    pandas
  ];

  propagatedBuildInputs = [
    appdirs
    click
    decorator
    logzero
    more-itertools
    mypy
    orjson
    pytz
    pdfannots
    gpxpy
    google-takeout-parser
    GitPython
    pinbexport
    goodrexport
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # /nix/store/iysjd0sb3pc1rakncazfm023n3ga95x2-python3-3.9.16/lib/python3.9/importlib/__init__.py:127
  doCheck = false;

  makeWrapperArgs = [
    "--prefix PYTHONPATH : ${python3.pkgs.makePythonPath propagatedBuildInputs}"
    "--prefix PYTHONPATH : $out/lib/${python3.libPrefix}/site-packages"
  ];

  meta = with lib; {
    description = "Human programming interface";
    homepage = "https://beepb00p.xyz/hpi.html";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
