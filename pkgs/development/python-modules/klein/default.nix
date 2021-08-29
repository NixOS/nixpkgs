{ lib, buildPythonPackage, fetchPypi, fetchpatch
, six, twisted, werkzeug, incremental
, mock }:

buildPythonPackage rec {
  pname = "klein";
  version = "17.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "30aaf0d78a987d5dbfe0968a07367ad0c73e02823cc8eef4c54f80ab848370d0";
  };

  patches = [
    (fetchpatch {
      name = "tests-expect-werkzeug-308.patch";
      url = "https://github.com/twisted/klein/commit/e2a5835b83e37a2bc5faefbfe1890c529b18b9c6.patch";
      sha256 = "03j0bj3l3hnf7f96rb27i4bzy1iih79ll5bcah7gybdi1wpznh8w";
    })
  ];

  propagatedBuildInputs = [ six twisted werkzeug incremental ];

  checkInputs = [ mock twisted ];

  checkPhase = ''
    trial klein
  '';

  meta = with lib; {
    description = "Klein Web Micro-Framework";
    homepage    = "https://github.com/twisted/klein";
    license     = licenses.mit;
  };
}
