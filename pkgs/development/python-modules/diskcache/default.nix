{ stdenv, lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, pytest-cov
, pytest-xdist, pytest-django, mock }:

buildPythonPackage rec {
  pname = "diskcache";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "grantjenks";
    repo = "python-diskcache";
    rev = "v${version}";
    sha256 = "sha256-dWtEyyWpg0rxEwyhBdPyApzgS9o60HVGbtY76ELHvX8=";
  };

  checkInputs = [ pytestCheckHook pytest-cov pytest-xdist pytest-django mock ];

  # Darwin sandbox causes most tests to fail.
  doCheck = !stdenv.isDarwin;
  pythonImportsCheck = [ "diskcache" ];

  disabledTests = [
    # very time sensitive, can fail on over subscribed machines
    "test_incr_update_keyerror"
  ];

  pytestFlagsArray = [ "-n $NIX_BUILD_CORES" ];

  meta = with lib; {
    description = "Disk and file backed persistent cache";
    homepage = "http://www.grantjenks.com/docs/diskcache/";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
