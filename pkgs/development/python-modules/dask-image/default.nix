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
  version = "0.1.2";
  pname = "dask-image";

  src = fetchPypi {
    inherit pname version;
    sha256 = "401e2c345a582eb2859a4a2a4a6fcfbc85beece59705f3ead9b6708a0cd183e7";
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
