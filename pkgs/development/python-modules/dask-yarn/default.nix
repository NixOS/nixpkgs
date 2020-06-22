{ buildPythonPackage
, dask
, distributed
, fetchPypi
, grpcio
, grpcio-tools
, pytest
, skein
, stdenv
}:

buildPythonPackage rec {
  version = "0.8.1";
  pname = "dask-yarn";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vdlzk3sgi77hpfl3k89ln6qk2m6zqb8hdfcrgw08q6awb97rfj4";
  };

  propagatedBuildInputs = [ dask distributed grpcio grpcio-tools skein ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/dask/dask-yarn";
    description = "Deploy dask on YARN clusters";
    license = licenses.bsd3;
    maintainers = [ maintainers.alexbiehl ];
  };
}
