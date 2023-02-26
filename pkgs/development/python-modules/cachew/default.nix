{ buildPythonPackage
, fetchFromGitHub
, lib
, appdirs
, more-itertools
, patchy
, pytestCheckHook
, pytz
, setuptools-scm
, sqlalchemy
, sqlite
}:

buildPythonPackage rec {
  pname = "cachew";
  version = "0.11.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "karlicoss";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-R268+zhf7MnIF5YTW+/zkdzEa6k4ZDk7upxA7yK05cA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    appdirs
    sqlalchemy
  ];

  checkInputs = [
    more-itertools
    patchy
    pytestCheckHook
    pytz
  ];

  doCheck = true;

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH=$PATH:${sqlite}/bin
  '';

  meta = with lib; {
    description = "Transparent and persistent cache/serialization powered by type hints";
    homepage = "https://github.com/karlicoss/cachew";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
