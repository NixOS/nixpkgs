{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools_scm
, pyvcd
, jinja2

# for tests
, pytestCheckHook
, yosys
, symbiyosys
, yices
}:

buildPythonPackage rec {
  pname = "nmigen";
  version = "unstable-2020-04-02";
  # python setup.py --version
  realVersion = "0.2.dev49+g${lib.substring 0 7 src.rev}";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nmigen";
    repo = "nmigen";
    rev = "c79caead33fff14e2dec42b7e21d571a02526876";
    sha256 = "sha256-3+mxHyg0a92/BfyePtKT5Hsk+ra+fQzTjCJ2Ech44/s=";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ setuptools pyvcd jinja2 ];

  checkInputs = [ pytestCheckHook yosys symbiyosys yices ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  meta = with lib; {
    description = "A refreshed Python toolbox for building complex digital hardware";
    homepage = "https://nmigen.info/nmigen";
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily ];
  };
}
