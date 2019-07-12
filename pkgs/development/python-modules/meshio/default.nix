{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, h5py
, lxml
, netcdf4
, pytest
, requests
, isPy27
}:

buildPythonPackage rec {
  pname = "meshio";
  version = "2.3.10";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "meshio";
    rev = "v${version}";
    sha256 = "090jiivxmsmqp1jlmhn8pxqwvr0p46l6nbrd5vmj6nq4v6a0lz90";
  };

  propagatedBuildInputs = [
    numpy
    h5py
    lxml
    netcdf4
  ];

  checkInputs = [
    pytest
    requests
  ];

  # 1-2 of each of these tests require network access so they are
  # diabled. otherwise all test pass without issue
  checkPhase = ''
    pytest test --ignore=test/test_abaqus.py \
                --ignore test/test_gmsh.py \
                --ignore test/test_med.py \
                --ignore test/test_vtk.py
  '';

  meta = with lib; {
    description = "I/O for various mesh formats";
    homepage = https://github.com/nschloe/meshio;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
