{ lib
, buildPythonPackage
, fetchPypi
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bugzilla";
  version = "2.3.0";

  src = fetchPypi {
    pname = "python-${pname}";
    inherit version;
    sha256 = "0q8c3k0kdnd11g2s56cp8va9365x0xfr2m2zn9fgxjijdyhwdic5";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
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
