{ lib,
  python3Packages,
  fetchPypi
}:
with python3Packages;
buildPythonApplication rec {
  pname = "watchgha";
  version = "2.4.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname;
    inherit version;
    hash = "sha256-RtmCC+twOk+viWY7WTbTzuxHTM3MOww+sRuEvlemCcI=";
  };

  buildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    dulwich
    exceptiongroup
    httpx
    rich
    trio
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Live display of current GitHub action runs";
    mainProgram = "watch_gha_runs";
    homepage = "https://github.com/nedbat/watchgha";
    license = licenses.apsl20;
    maintainers = with maintainers; [ purcell ];
    platforms = platforms.all;
  };
}
