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
  version = "0.2.0";
  pname = "dask-image";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bece2ea347f963dc0168c7d5fdfd11e51b47d9c857d3bc56144d7c146964a23f";
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
