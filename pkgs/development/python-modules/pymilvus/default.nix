{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, grpcio-tools
, ujson
, grpcio
, pandas
, mmh3
, setuptools-scm
}:
buildPythonPackage rec {
  pname = "pymilvus";
  version = "2.2.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/i3WObwoY6Ffqw+Guij6+uGbKYKET2AJ+d708efmSx0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    grpcio
    grpcio-tools
    ujson
    pandas
    mmh3
  ] ++ lib.optionals stdenv.isLinux [ setuptools-scm ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/milvus-io/pymilvus";
    description = "Python SDK for Milvus. ";
    license = licenses.mit;
    maintainers = with maintainers; [happysalada];
  };
}
