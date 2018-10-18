{ stdenv
, buildPythonPackage
, fetchPypi
, dask
, numpy, toolz # dask[array]
, scipy
, pims
, pytest
, scikitimage
}:

buildPythonPackage rec {
  version = "0.1.1";
  pname = "dask-image";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e6294ac577a8fc0abec2b97a2c42d404f599feac61d6899bdf1bf2b7cfb0e015";
  };

  checkInputs = [ pytest scikitimage ];
  propagatedBuildInputs = [ dask numpy toolz scipy pims ];

  meta = with stdenv.lib; {
    homepage = https://github.com/dask/dask-image;
    description = "Distributed image processing";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
