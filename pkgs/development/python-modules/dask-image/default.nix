{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, dask
, scipy
, pims
, scikitimage
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "2021.12.0";
  pname = "dask-image";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35be49626bd01c3e3892128126a27d5ee3266a198a8e3c7e30d59eaef712fcf9";
  };

  propagatedBuildInputs = [ dask scipy pims ];

  prePatch = ''
    substituteInPlace setup.cfg --replace "--flake8" ""
  '';

  checkInputs = [
    pytestCheckHook
    scikitimage
  ];

  pythonImportsCheck = [ "dask_image" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://github.com/dask/dask-image";
    description = "Distributed image processing";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
