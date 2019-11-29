{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools_scm
, pyvcd
, bitarray
, jinja2

# for tests
, yosys
, symbiyosys
, yices
}:

buildPythonPackage rec {
  pname = "nmigen";
  version = "unstable-2019-10-17";
  # python setup.py --version
  realVersion = "0.1.rc2.dev5+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "nmigen";
    rev = "9fba5ccb513cfbd53f884b1efca699352d2471b9";
    sha256 = "02bjry4sqjsrhl0s42zl1zl06gk5na9i6br6vmz7fvxic29vl83v";
  };

  disabled = pythonOlder "3.6";

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ setuptools pyvcd bitarray jinja2 ];

  checkInputs = [ yosys symbiyosys yices ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  meta = with lib; {
    description = "A refreshed Python toolbox for building complex digital hardware";
    homepage = https://github.com/m-labs/nmigen;
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily ];
  };
}
