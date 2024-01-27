{ lib
, buildPythonPackage
, fetchPypi
, requests
, pytestCheckHook
, glibcLocalesUtf8
}:

buildPythonPackage rec {
  pname = "bugzilla";
  version = "3.2.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "python-${pname}";
    inherit version;
    sha256 = "TvyM+il4N8nk6rIg4ZcXZxW9Ye4zzsLBsPJ5DweGA4c=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook glibcLocalesUtf8
  ];

  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';

  meta = with lib; {
    homepage = "https://github.com/python-bugzilla/python-bugzilla";
    description = "Bugzilla XMLRPC access module";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pierron ];
  };
}
